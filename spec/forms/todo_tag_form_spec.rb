require 'rails_helper'

RSpec.describe TodoTagForm, :type => :model do
  before do
    @form = FactoryBot.build(:todo_tag_form)
  end

  it 'タイトルが必須であること' do
    @form.title = ' '
    expect(@form).to_not be_valid
  end

  it 'タイトルが50字以内であること' do
    @form.title = 'a' * 51
    expect(@form).to_not be_valid
  end

  it 'textが必須であること' do
    @form.text = ' '
    expect(@form).to_not be_valid
  end

  it 'textが140字以内であること' do
    @form.title = 'a' * 141
    expect(@form).to_not be_valid
  end

  it '終了期日が必須であること' do
    @form.limit_date = ' '
    expect(@form).to_not be_valid
  end

  it 'ステータスが必須であること' do
    @form.status = ' '
    expect(@form).to_not be_valid
  end

  it '初期値が未完了であること' do
    expect(@form.status).to eq '未完了'
  end

  describe 'カスタムバリデーション' do
    it 'pretend_ago' do
      @form.status = '未完了'
      @form.limit_date = Time.current.yesterday
      expect(@form).to_not be_valid
    end

    it 'validate_tags' do
      @form.name = 'a' * 11
      expect(@form).to_not be_valid
    end

    it 'file_length' do
      @form.images.attach(io: File.open('spec/fixtures/files/image/test_image.png'), filename: 'test_image.png', content_type: 'image/png')
      @form.images.attach(io: File.open('spec/fixtures/files/image/test_image.png'), filename: 'test_image.png', content_type: 'image/png')
      @form.images.attach(io: File.open('spec/fixtures/files/image/test_image.png'), filename: 'test_image.png', content_type: 'image/png')
      expect(@form).to_not be_valid
    end

    context 'タスクtag数の制限' do
      let!(:todo) { create(:todo)}
      let!(:tag) { create(:tag) }
      before do
        10.times do |i|
          tag = Tag.create(name: "tag#{i}", user_id: todo.user.id)
          todo.todo_tags.create(tag_id: tag.id)
        end
      end
      it 'limit_tags_per_todo' do
        expect(todo).to_not be_valid
      end
    end

    context 'ユーザーtag数の制限' do
      let!(:todo) { create(:todo)}
      let!(:tag) { create(:tag) }
      before do
        100.times do |i|
          tag = Tag.create(name: "user_tag#{i}", user_id: todo.user.id)
          todo.todo_tags.create(tag_id: tag.id)
        end
      end
      it 'limit_tags_per_user' do
        expect(tag).to_not be_valid
      end
    end
  end
end