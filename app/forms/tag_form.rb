class TagForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :name, :user_id
  attr_reader :tag

  validates :name, presence: true, length: { maximum: 10 }

  delegate :persisted?, to: :tag

  def initialize(attributes = nil, tag: Tag.new)
    @tag = tag
    attributes ||= default_attributes
    super(attributes)
  end

  def save
    return if invalid?

    ActiveRecord::Base.transaction do
      tag.update!(name:, user_id:)
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  def to_model
    tag
  end

  private

  def default_attributes
    {
      name: tag.name,
      user_id: tag.user_id
    }
  end
end
