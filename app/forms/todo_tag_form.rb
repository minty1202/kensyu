class TodoTagForm
  include ActiveModel::Model
  include ActiveRecord::AttributeAssignment

  attr_accessor :title, :text, :limit_date, :status, :name, :user_id, :images, :tag_ids

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

  def initialize(todo = Todo.new, **attributes)
    @todo = todo
    attributes = { title: todo.title, text: todo.text, limit_date: todo.limit_date, status: todo.status } if attributes.empty?
    super(attributes)
  end

  def save
    return if valid?

    todo.update!(title: todo.title, text: todo.text, limit_date: todo.limit_date, status: todo.status)
  rescue ActiveRecord::RecordInvalid
    false
  end

  def udpate(params)
    self.attributes = params
    save
  end

  def to_model
    todo
  end

  private

  attr_reader :todo

  def file_length
    return errors.add(:images, 'は3ファイルまでにしてください') if images.length > 3
  end

  def pretend_ago
    errors.add(:limit_date, 'は先の日付にしてください') if limit_date.nil? || limit_date < Date.today #nilまたは過去の日付ならエラー
  end
end
