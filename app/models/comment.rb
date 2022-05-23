class Comment < ApplicationRecord
  validates :comment_text, presence: true, length: {maximum: 140}
  belongs_to :user
  belongs_to :todo
end
