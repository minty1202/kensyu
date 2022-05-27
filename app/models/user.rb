class User < ApplicationRecord
  include Search

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  validates :name, presence: true, length: { maximum: 10 }
  has_many :todos, dependent: :destroy
  has_many :comments, dependent: :destroy, through: :todos
end
