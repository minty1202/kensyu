class TagForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :name, :user_id

  validates :name, presence: true, length: { maximum: 10 }

  delegate :persisted?, to: :@tag

  def initialize(attributes = nil, tag: Tag.new)
    @tag = tag
    attributes ||= default_attributes
    super(attributes)
  end

  def save
    return if invalid?

    @tag.name = name
    @tag.save!
  rescue ActiveRecord::RecordInvalid
    false
  end

  def to_model
    @tag
  end

  private

  def default_attributes
    {
      name: @tag.name,
      user_id: @tag.user_id
    }
  end
end
