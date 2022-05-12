class Todo < ApplicationRecord
  validates :title, presence: true, length: {maximum: 50}
  validates :text, presence: true
  belongs_to :user
end
