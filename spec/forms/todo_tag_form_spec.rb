require 'rails_helper'

RSpec.describe TodoTagForm, type: :model do

  describe 'バリデーション機能テスト' do
    before { form.valid? }

    describe 'タイトルバリデーションテスト' do
      subject { form.errors[:title] }

      context 'タイトルが空欄のとき' do
        let!(:form) { build(:todo_tag_form, title: ' ') }
        it { is_expected.to be_present}
      end
  
      context 'タイトルが50字以上のとき' do
        let!(:form) { build(:todo_tag_form, title: 'a' * 51) }
        it { is_expected.to be_present}
      end
    end

    describe 'テキストバリデーションテスト' do
      subject { form.errors[:text] }

      context 'textが空欄のとき' do
        let!(:form) { build(:todo_tag_form, text: ' ') }
        it { is_expected.to be_present}
      end

      context 'textが141字以上のとき' do
        let!(:form) { build(:todo_tag_form, text: 'a' * 141) }
        it { is_expected.to be_present}
      end
    end

    describe '画像バリデーションテスト' do
      subject { form.errors[:images] }

      context 'FIXME: (これはどういうケースのテストだろう)' do
        let!(:form) do 
          build(:todo_tag_form) do |f|
            3.times do
              f.images.attach(io: File.open('spec/fixtures/files/image/test_image.png'), filename: 'test_image.png', content_type: 'image/png')
            end
          end
        end

        it { is_expected.to be_present}
      end
    end
  end

  describe 'もとのコード' do
    let!(:form) { build(:todo_tag_form, title: ' ') }
  
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
      let!(:todo) { create(:todo) }
      before do
        5.times do |i|
          todo.tags.create(name: "user_tag#{i}", user_id: todo.user.id)
        end
      end
      it 'limit_tags_per_todo' do
        form = TodoTagForm.new(todo:)
        form.user_id = todo.user.id
        form.title = 'title'
        form.text = 'text'
        form.limit_date = Time.current
        form.name = '1, 2, 3, 4, 5, 6'
        form.save
        expect(form.errors[:name]).to include('は10個以上登録できません。')
      end
    end
  
    context 'ユーザーtag数の制限' do
      let!(:user) { create(:user) }
      let!(:todo0) { create(:todo, user:) }
  
      # todoを10個作成
      # 1つのtodoに対して10個のタグを作成。（合計100個のタグ）
      before do
        10.times do |_i|
          todo = create(:todo)
          10.times do |i|
            todo.tags.create(name: "user_tag#{i + 1}", user_id: user.id)
          end
        end
      end
  
      it 'limit_tags_per_user' do
        form = TodoTagForm.new(todo: todo0)
        form.user_id = user.id
        form.title = 'title'
        form.text = 'text'
        form.limit_date = Time.current
        form.name = '101'
        form.save
        expect(form.errors[:name]).to include('は1ユーザー100個までしか登録できません')
      end
    end
  end
end
