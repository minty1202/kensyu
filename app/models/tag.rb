class Tag < ApplicationRecord
  has_many :todo_tags, dependent: :destroy, foreign_key: 'tag_id'
  has_many :todos, through: :todo_tags
end
