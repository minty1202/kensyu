class TodoTagForm
  include ActiveModel::Model

  attr_accessor :title, :text, :limit_date, :status, :name, :user_id, :tag_ids, :images, :image_ids

  # todo
  validates :title, presence: true, length: { maximum: 50 }
  validates :text, presence: true, length: { maximum: 140 }
  validates :limit_date, presence: true
  validates :status, presence: true
  validate :pretend_ago
  validate :file_length

  # tag
  validate :validate_tags
  validate :limit_tags_per_todo
  validate :limit_tags_per_user

  delegate :persisted?, to: :@todo

  # Formオブジェクトの値の初期化
  def initialize(attributes = nil, todo: Todo.new)
    @todo = todo
    attributes ||= default_attributes
    super(attributes)
  end

  def save
    return if invalid?

    ActiveRecord::Base.transaction do
      split_tag_names.each { |name| @todo.tags.find_or_initialize_by(name:, user_id:) }
      return if invalid?
      delete_tag_image
      @todo.update!(title:, text:, limit_date:, status:, user_id:, images:)
    end
  rescue ActiveRecord::RecordInvalid => e
    puts e.record.errors
    false
  end

  def to_model
    @todo
  end

  private

  def default_attributes
    {
      title: @todo.title,
      text: @todo.text,
      limit_date: @todo.limit_date,
      status: @todo.status,
      name: @todo.tags.pluck(:name).join(','),
      user_id: @todo.user_id,
      images: @todo.images
    }
  end

  def delete_tag_image
    image_ids&.each { |delete_image| ActiveStorage::Attachment.find(delete_image).purge } if image_ids
    tag_ids&.each { |delete_tag| @todo.tags.find(delete_tag).destroy! } unless tag_ids.nil?
  end

  def split_tag_names
    name.gsub(/\s+/, "").split(',')
  end

  def pretend_ago
    return if status == '完了' || status == '期限切れ'
    return if limit_date == ''

    errors.add(:limit_date, 'は先の日付にしてください') if limit_date < Time.current.yesterday
  end

  def validate_tags
    split_tag_names.each do |tag|
      errors.add(:base, "#{tag}は10文字以下にしてください") if tag.size > 10
    end
  end

  def limit_tags_per_todo
    errors.add(:name, "は10個以上登録できません。") if @todo.tags.size > 10
  end

  def limit_tags_per_user
    errors.add(:name, "は1ユーザー100個までしか登録できません") if @todo.user && @todo.user.tags.size > 20
  end

  def file_length
    # バリデーションかける数 = 新しく追加する数 + 既存の数 - 削除する数
    images_count = images.reject(&:blank?).count + @todo.images.count - image_ids.to_a.count
    errors.add(:images, 'は3ファイルまでにしてください') if images_count > 3
  end
end
