class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  validates :name, presence: true, length: { maximum: 10 }
  has_many :todos, dependent: :destroy
  has_many :comments, dependent: :destroy, through: :todos
  has_many :tags, dependent: :destroy

  MINIMUM_PASSWORD_LENGTH = 6
  MAXIMUM_PASSWORD_LENGTH = 128
end
