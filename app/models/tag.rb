class Tag < ApplicationRecord
  validates :title, presence: true, length: { maximum: 10 }

  belongs_to :user
  has_many :todo_tags, dependent: :destroy, foreign_key: 'tag_id'
  has_many :todos, through: :todo_tags
end
