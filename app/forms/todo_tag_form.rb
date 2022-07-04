class TodoTagForm
  include ActiveModel::Model
  include ActiveRecord::AttributeAssignment

  attr_accessor :title, :text, :limit_date, :status, :name, :user_id, :images, :tag_ids
  attr_reader :todo, :tag

  #todo
  validates :title, presence: true, length: { maximum: 50 }
  validates :text, presence: true, length: { maximum: 140 }
  validates :limit_date, presence: true
  validates :status, presence: true
  validate :file_length

  with_options on: :no_change do
    validate :pretend_ago
  end

  # tag
  validates :name, length: { maximum: 10 }

  delegate :persisted?, to: :todo

  # form objectの値を初期化
  def initialize(attributes = nil, todo = Todo.new, tag = Tag.new)
    @todo = todo
    @tag = tag
    attributes ||= default_attributes
    super(attributes)
  end

  def save
    ActiveRecord::Base.transaction do
      Todo.create(title: todo.title, text: todo.text, limit_date: todo.limit_date, status: todo.status)
      Tag.create(name:tag.name, user_id: tag.user_id)
    end
  rescue ActiveRecord::RecordInvalid
      false
  end

  def update
    ActiveRecord::Base.transaction do
      todo.update(title: todo.title, text: todo.text, limit_date: todo.limit_date, status: todo.status)
      Tag.update(name:tag.name, user_id: tag.user_id)
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

  def default_attributes
    {
    title: todo.title,
    text: todo.text,
    limit_date: Time.current.since(3.days),
    status: todo.status,
    name: tag.name,
    user_id: tag.user_id
    }
  end

  def file_length
    return errors.add(:images, 'は3ファイルまでにしてください') if images.length > 3
  end

  def pretend_ago
    errors.add(:limit_date, 'は先の日付にしてください') if limit_date.nil? || limit_date < Date.today #nilまたは過去の日付ならエラー
  end
end
