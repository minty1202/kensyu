# ------------------tagのみ-------------------------------------

class TagForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :name, :user_id

  validates :split_tags, presence: true, length: { maximum: 10 }

  delegate :persisted?, to: :tag

  def initialize(attributes = nil, tag: Tag.new)
    @tag = tag
    attributes ||= default_attributes
    super(attributes)
  end

  def save
    return if invalid?

    ActiveRecord::Base.transaction do
      split_tags.map { |tag| Tag.find_or_create_by!(name: tag, user_id: current_user.id) }
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  def to_model
    tag
  end

  private

  attr_reader :tag

  def default_attributes
    {
      name: tag.name,
      user_id: tag.user_id
    }
  end

  def split_tags
    name.gsub(/\s+/, "").split(',')
  end
end


# --------------------todo & tag----------------------------
# class TodoTagForm
#   include ActiveModel::Model
#   include ActiveModel::Attributes

#   attr_accessor :title, :text, :limit_date, :status, :tag_names

#   # todo
#   validates :title, presence: true, length: { maximum: 50 }
#   validates :text, presence: true, length: { maximum: 140 }
#   validates :limit_date, presence: true
#   validates :status, presence: true
#   validate :file_length

#   # tag
#   validates :name, length: { maximum: 10 }

#   delegate :persisted?, to: :todo

#   # Formオブジェクトの値の初期化
#   def initialize(attributes = nil, todo: Todo.new)
#     @todo = todo
#     attributes ||= default_attributes
#     super(attributes)
#   end

#   def save
#     return if invalid?

#     ActiveRecord::Base.transaction do
#       tags = split_tag_names.map { |name| Tag.find_or_create_by!(name: name) }
#       todo.update!(title: title, text: text, limit_date: limit_date, status: status, tags: tags)
#     end
#   rescue ActiveRecord::RecordInvalid
#     false
#   end

#   def to_model
#     todo
#   end

#   private

#   attr_reader :todo

#   def default_attributes
#     {
#       title: todo.title,
#       text: todo.text,
#       limit_date: todo.limit_date,
#       status: todo.status,
#       name: todo.tags.pluck(:name).join(','),
#       # user_id: todo.user_id
#     }
#   end

#   def split_tag_names
#     tag_names.split(',')
#   end
# end