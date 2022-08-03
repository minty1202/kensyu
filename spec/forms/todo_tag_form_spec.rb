require 'rails_helper'

RSpec.describe TodoTagForm, :type => :model do
  before do
    @form = FactoryBot.build(:todo_tag_form)
  end

  it 'タイトルが必須であること' do
    @form.title = ' '
    @form.valid?
    expect(@form.errors[:title]).to be_present
  end

  it 'タイトルが50字以内であること' do
    @form.title = 'a' * 51
    @form.valid?
    expect(@form.errors[:title]).to be_present
  end

  it 'textが必須であること' do
    @form.text = ' '
    @form.valid?
    expect(@form.errors[:text]).to be_present
  end

  it 'textが140字以内であること' do
    @form.text = 'a' * 141
    @form.valid?
    expect(@form.errors[:text]).to be_present
  end

  it '終了期日が必須であること' do
    @form.limit_date = ''
    @form.valid?
    expect(@form.errors[:limit_date]).to be_present
  end

  it 'ステータスが必須であること' do
    @form.status = ' '
    @form.valid?
    expect(@form.errors[:status]).to be_present
  end

  it '初期値が未完了であること' do
    expect(@form.status).to eq '未完了'
  end

  describe 'カスタムバリデーション' do
    it 'pretend_ago' do
      @form.status = '未完了'
      @form.limit_date = Time.current.ago(3.days)
      @form.valid?
      expect(@form.errors[:limit_date]).to be_present
    end

    it 'validate_tags' do
      @form.name = 'a' * 11
      @form.valid?
      expect(@form.errors[:base]).to be_present
    end

    it 'file_length' do
      @form.images.attach(io: File.open('spec/fixtures/files/image/test_image.png'), filename: 'test_image.png', content_type: 'image/png')
      @form.images.attach(io: File.open('spec/fixtures/files/image/test_image.png'), filename: 'test_image.png', content_type: 'image/png')
      @form.images.attach(io: File.open('spec/fixtures/files/image/test_image.png'), filename: 'test_image.png', content_type: 'image/png')
      @form.valid?
      expect(@form.errors[:images]).to be_present
    end

    context 'タスクtag数の制限' do
      let!(:todo) { create(:todo)}
      before do
        5.times do |i|
          tag = Tag.create(name: "tag#{i}", user_id: todo.user.id)
          todo.todo_tags.create(tag_id: tag.id)
        end
      end
      it 'limit_tags_per_todo' do
        @form2 = TodoTagForm.new(todo: todo)
        @form2.user_id = todo.user.id
        @form2.title = 'title'
        @form2.text = 'text'
        @form2.limit_date = Time.current
        @form2.name = '1, 2, 3, 4, 5, 6'
        @form2.save

        expect(@form2.errors[:name]).to include('は10個以上登録できません。')
      end
    end

    context 'ユーザーtag数の制限' do
      let!(:todo) { create(:todo)}
      before do
        10.times do |i|
          tag = Tag.create(name: "user_tag#{i}", user_id: todo.user.id)
          todo.todo_tags.create(tag_id: tag.id)
        end
      end
      it 'limit_tags_per_user' do
        @form3 = TodoTagForm.new(todo: todo)
        @form3.title = 'title'
        @form3.text = 'text'
        @form3.limit_date = Time.current
        @form3.name = '1, 2, 3, 4, 5, 6, 7,8, 9, 10, 11'
        p todo.user.tags.size
        @form3.save
        p @form3.name
        @form3.valid?
        p @form3.errors
        expect(@form3.errors[:name]).to include('は1ユーザー100個までしか登録できません')
      end
    end
  end
end