class Todo < ApplicationRecord
  include Search

  validates :title, presence: true, length: { maximum: 50 }
  validates :text, presence: true
  validates :limit_date, presence: true
  validates :status, presence: true
  validate :file_length
  has_many_attached :images do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
  end
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :todo_tags, dependent: :destroy
  has_many :tags, through: :todo_tags

  enum status: { '未完了': 'todo', '完了': 'done', '期限切れ': 'expired' }

  def save_tag(sent_tags)
    current_tags = tags.pluck(:name)

    old_tags = current_tags - sent_tags
    new_tags = sent_tags - current_tags

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

  private

  def file_length
    return errors.add(:images, 'は3ファイルまでにしてください') if images.length > 3
  end
end
