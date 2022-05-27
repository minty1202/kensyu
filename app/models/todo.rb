class Todo < ApplicationRecord
  validates :title, presence: true, length: { maximum: 50 }
  validates :text, presence: true
  validate :file_length
  has_many_attached :images do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
  end
  belongs_to :user
  has_many :comments, dependent: :destroy

  class << self
    def lookfor(search, word)
      case search
      when "perfect_match"
        Todo.includes(:user).where("title LIKE ?", word.to_s)
      when "forward_match"
        Todo.includes(:user).where("title LIKE ?", word.to_s.concat('%'))
      when "backward_match"
        Todo.includes(:user).where("title LIKE ?", '%'.concat(word.to_s))
      when "partial_match"
        Todo.includes(:user).where("title LIKE ?", '%'.concat(word.to_s).concat('%'))
      else
        Todo.includes(:user)
      end
    end
  end

  private

  def file_length
    return errors.add(:images, 'は3ファイルまでにしてください') if images.length > 3
  end
end
