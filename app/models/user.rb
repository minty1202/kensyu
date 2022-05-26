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
        @user = User.includes(:todos).where("name LIKE ?", "#{word}")
      when "forward_match"
        @user = User.includes(:todos).where("name LIKE ?", "#{word}%")
      when "backward_match"
        @user = User.includes(:todos).where("name LIKE ?", "%#{word}")
      when "partial_match"
        @user = User.includes(:todos).where("name LIKE ?", "%#{word}%")
      else
        @user = User.includes(:todos)
      end
    end
  end
end
