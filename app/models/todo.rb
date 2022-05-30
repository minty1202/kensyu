class Todo < ApplicationRecord
  include Search

  validates :title, presence: true, length: { maximum: 50 }
  validates :text, presence: true
  validate :file_length
  has_many_attached :images do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
  end
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :todo_tags, dependent: :destroy
  has_many :tags, through: :todo_tags

  def save_tag(sent_tags)
    puts '---------------------'
    puts '------------sent_tags---------'
    pp sent_tags
    # pp '-----------------------'
    # pp '----------self.tags-------------'
    # pp self.tags.empty? #true , should be false

    current_tags = self.tags.pluck(:name) #unless self.tags.nil? #現在存在するタグの取得
    puts '------------------------------'
    puts '---------------current_tags---------------'
    pp current_tags # [] tagは何も登録されていない？

    old_tags = current_tags - sent_tags #古いタグの取得
    new_tags = sent_tags - current_tags #新しいタグの取得

    puts '-----before------------'
    puts '------new_tags-----------'
    pp new_tags

    # 古いタグの削除
    old_tags.each do |old|
      self.todo_tags.delete Tag.find_by(name: old)
    end

    #新しいタグの保存
    new_tags.each do |new|
      new_todo_tag = Tag.find_or_create_by(name: new)
      puts '-----------------'
      puts '------new_todo_tag-----------'
      pp new_todo_tag
      # self.todo_tags << new_todo_tag #末尾に追加
    end
  end

  private

  def file_length
    return errors.add(:images, 'は3ファイルまでにしてください') if images.length > 3
  end
end
