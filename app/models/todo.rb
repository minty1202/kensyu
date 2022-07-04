class Todo < ApplicationRecord
  validates :title, presence: true, length: { maximum: 50 }
  validates :text, presence: true, length: { maximum: 140 }
  validates :limit_date, presence: true
  validates :status, presence: true
  validate :file_length, unless: -> { validation_context == :to_delete_images } # context: :to_delete_images以外のときだけバリデーションする
  has_many_attached :images do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
  end
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :todo_tags, dependent: :destroy
  has_many :tags, through: :todo_tags

  enum status: { '未完了': 'todo', '完了': 'done', '期限切れ': 'expired' }

  scope :search_title, ->(word) { where("title LIKE ?", "%#{word}%").order(limit_date: "ASC") }
  scope :search_text, ->(word) { where("text LIKE ?", "%#{word}%").order(limit_date: "ASC") }

  def save_tag(new_sent_tags = nil, checkbox_sent_tags = [])
    checkbox_tags = Tag.find(checkbox_sent_tags)
    checkbox_tags = checkbox_tags.pluck(:name)

    all_sent_tags = new_sent_tags + checkbox_tags

    current_tags = tags.pluck(:name)

    old_tags = current_tags - all_sent_tags
    new_tags = all_sent_tags - current_tags

    # 古いタグの削除
    old_tags.each do |old|
      tags.delete(Tag.find_by(name: old, user_id:))
    end

    # 新しいタグの保存
    new_tags.each do |new_tag|
      new_todo_tag = Tag.find_or_create_by(name: new_tag, user_id:)
      tags << new_todo_tag
    end
  end

  def self.change_status
    timeout_todos = Todo.where("limit_date < ?", Time.current).where(status: 'todo')
    timeout_todos.find_each do |timeout_todo|
      timeout_todo.status = 'expired'
      timeout_todo.save
    end
  end

  # 1日後に終了期限かつ未完了のTodoを取得して通知
  def self.notice_expired_todo
    notifier = Slack::Notifier.new(ENV['WEBHOOK_URL'])
    expired_tomorrow_todos = Todo.where(limit_date: Time.current.tomorrow).where(status: 'todo')

    return if expired_tomorrow_todos.count.zero?

    todo_title = expired_tomorrow_todos.pluck(:title)
    all_todo_title = todo_title.join("\n")
    notifier.ping "明日期限の未完了Todoは#{expired_tomorrow_todos.count}件です。\n#{all_todo_title}"
  end

  private

  def file_length
    return errors.add(:images, 'は3ファイルまでにしてください') if images.length > 3
  end
end
