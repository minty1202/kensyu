require 'rails_helper'

RSpec.describe TodoTagForm, :type => :model do
  let!(:form) {build(:todo_tag_form)}

  it 'タイトルが必須であること' do
    form.title = ' '
    form.valid?
    expect(form.errors[:title]).to be_present
  end

  it 'タイトルが50字以内であること' do
    form.title = 'a' * 51
    form.valid?
    expect(form.errors[:title]).to be_present
  end

  it 'textが必須であること' do
    form.text = ' '
    form.valid?
    expect(form.errors[:text]).to be_present
  end

  it 'textが140字以内であること' do
    form.text = 'a' * 141
    form.valid?
    expect(form.errors[:text]).to be_present
  end

  it '終了期日が必須であること' do
    form.limit_date = ''
    form.valid?
    expect(form.errors[:limit_date]).to be_present
  end

  it 'ステータスが必須であること' do
    form.status = ' '
    form.valid?
    expect(form.errors[:status]).to be_present
  end

  it '初期値が未完了であること' do
    expect(form.status).to eq '未完了'
  end

  describe 'カスタムバリデーション' do
    it 'pretend_ago' do
      form.status = '未完了'
      form.limit_date = Time.current.ago(3.days)
      form.valid?
      expect(form.errors[:limit_date]).to be_present
    end

    it 'validate_tags' do
      form.name = 'a' * 11
      form.valid?
      expect(form.errors[:base]).to be_present
    end

    it 'file_length' do
      form.images.attach(io: File.open('spec/fixtures/files/image/test_image.png'), filename: 'test_image.png', content_type: 'image/png')
      form.images.attach(io: File.open('spec/fixtures/files/image/test_image.png'), filename: 'test_image.png', content_type: 'image/png')
      form.images.attach(io: File.open('spec/fixtures/files/image/test_image.png'), filename: 'test_image.png', content_type: 'image/png')
      form.valid?
      expect(form.errors[:images]).to be_present
    end

    context 'タスクtag数の制限' do
      let!(:todo) { create(:todo)}
      before do
        5.times do |i|
          todo.tags.create(name: "user_tag#{i}", user_id: todo.user.id)
        end
      end
      it 'limit_tags_per_todo' do
        form2 = TodoTagForm.new(todo: todo)
        form2.user_id = todo.user.id
        form2.title = 'title'
        form2.text = 'text'
        form2.limit_date = Time.current
        form2.name = '1, 2, 3, 4, 5, 6'
        form2.save
        expect(form2.errors[:name]).to include('は10個以上登録できません。')
      end
    end

    context 'ユーザーtag数の制限' do
      let!(:user) { create(:user)}
      let!(:todo0) { create(:todo, user: user)}

      # todoを10個作成
      #1つのtodoに対して10個のタグを作成。（合計100個のタグ）
      before do
        10.times do |i|
          todo = FactoryBot.create(:todo)
          10.times do |i|
            todo.tags.create(name: "user_tag#{i + 1}", user_id: user.id)
          end
        end
      end

      it 'limit_tags_per_user' do
        form3 = TodoTagForm.new(todo: todo0)
        form3.user_id = user.id
        form3.title = 'title'
        form3.text = 'text'
        form3.limit_date = Time.current
        form3.name = '101'
        form3.save
        expect(form3.errors[:name]).to include('は1ユーザー100個までしか登録できません')
      end
    end
  end
end