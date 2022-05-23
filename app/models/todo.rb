class Todo < ApplicationRecord
  validates :title, presence: true, length: {maximum: 50}
  validates :text, presence: true
  validate :file_length
  has_many_attached :images do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
  end
  belongs_to :user

  private
    def file_length
      if images.length > 3
        errors.add(:images, 'は3ファイルまでにしてください')
      end
    end
end
