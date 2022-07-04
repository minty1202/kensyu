class Tag < ApplicationRecord
  validates :name, length: { maximum: 10 }
  validate :limit_number_of_tags

  belongs_to :user
  has_many :todo_tags, dependent: :destroy, foreign_key: 'tag_id'
  has_many :todos, through: :todo_tags

  def self.change_tag_order
    select('tags.*', 'count(todo_tags.id) AS todo_tags')
      .left_joins(:todo_tags)
      .group('id')
      .order('todo_tags desc')
  end

  def limit_number_of_tags
    errors.add(:name, "は100個以上登録できません。") if user && user.tags.count > 100
  end
end
