class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  validates :name, presence: true, length: { maximum: 10 }
  has_many :todos, dependent: :destroy
  has_many :comments, dependent: :destroy, through: :todos

  class << self
    def lookfor(search, word)
      case search
      when "perfect_match"
        User.includes(:todos).where("name LIKE ?", word.to_s)
      when "forward_match"
        User.includes(:todos).where("name LIKE ?", word.to_s.concat('%'))
      when "backward_match"
        User.includes(:todos).where("name LIKE ?", '%'.concat(word.to_s))
      when "partial_match"
        User.includes(:todos).where("name LIKE ?", '%'.concat(word.to_s).concat('%'))
      else
        User.includes(:todos)
      end
    end
  end
end
