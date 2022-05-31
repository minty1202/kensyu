class Tag < ApplicationRecord
  validates :name, presence: true, length: { maximum: 10 }

  belongs_to :user
  has_many :todo_tags, dependent: :destroy, foreign_key: 'tag_id'
  has_many :todos, through: :todo_tags

  # def change_tag(sent_tags)
  #   current_tags = self.tags.pluck(:name) #unless self.tags.nil? #現在存在するタグの取得

  #   old_tags = current_tags - sent_tags #古いタグの取得
  #   new_tags = sent_tags - current_tags #新しいタグの取得
  # end
end
