require 'rails_helper'

RSpec.describe TodoTagForm, type: :model do
  describe 'バリデーション機能テスト' do
    before { form.valid? }

    describe 'タイトルバリデーションテスト' do
      subject { form.errors[:title] }

      context 'タイトルが空欄のとき' do
        let!(:form) { build(:todo_tag_form, title: ' ') }
        it { is_expected.to be_present }
      end

      context 'タイトルが51文字以上のとき' do
        let!(:form) { build(:todo_tag_form, title: 'a' * 51) }
        it { is_expected.to be_present }
      end
    end

    describe 'テキストバリデーションテスト' do
      subject { form.errors[:text] }

      context 'テキストが空欄のとき' do
        let!(:form) { build(:todo_tag_form, text: ' ') }
        it { is_expected.to be_present }
      end

      context 'テキストが141文字以上のとき' do
        let!(:form) { build(:todo_tag_form, text: 'a' * 151) }
        it { is_expected.to be_present }
      end
    end

    describe '画像バリデーションテスト' do
      subject { form.errors[:images] }

      context '画像が4枚以上のとき' do
        let!(:form) do
          build(:todo_tag_form) do |f|
            4.times do
              f.images.attach(io: File.open('spec/fixtures/files/image/test_image.png'), filename: 'test_image.png', content_type: 'image/png')
            end
          end
        end
        it { is_expected.to be_present }
      end
    end

    describe '終了期日のバリデーションテスト' do
      subject { form.errors[:limit_date] }

      context '終了期日が空欄のとき' do
        let!(:form) { build(:todo_tag_form, limit_date: '') }
        it { is_expected.to be_present }
      end

      context '終了期日が過去の日付のとき(pretend_ago)' do
        let!(:form) { build(:todo_tag_form, limit_date: Time.current.ago(3.days)) }
        it { is_expected.to be_present }
      end
    end

    describe 'ステータスのバリデーションテスト' do
      subject { form.errors[:status] }

      context 'ステータスが空欄のとき' do
        let!(:form) { build(:todo_tag_form, status: ' ') }
        it { is_expected.to be_present }
      end

      context 'ステータスの初期値は未完了であること' do
        let!(:form) { build(:todo_tag_form) }
        it { expect(form.status).to eq '未完了' }
      end
    end

    describe 'タグのバリデーションテスト' do
      subject { form.errors[:base] }

      context 'タグの文字数が11文字以上のとき' do
        let!(:form) { build(:todo_tag_form, name: 'a' * 11) }
        it { is_expected.to be_present }
      end
    end
  end

  describe 'タグ数の制限テスト' do
    subject { form.errors[:name] }

    let!(:user) { create(:user) }
    let!(:todo) { create(:todo, user:) }
    let!(:form) do
      TodoTagForm.new(todo:) do
        form.user_id = user.id
        form.title = 'title'
        form.text = 'text'
        form.limit_date = Time.current
      end
    end

    context '1つのTodoに11個以上のタグを登録しようとするとき' do
      # あらかじめ5個のタグを登録しておく
      before do
        5.times do |i|
          todo.tags.create(name: "user_tag#{i}", user_id: todo.user.id)
        end
      end
      it '[10個以上登録できません]というエラー文言があること' do
        form.name = '1, 2, 3, 4, 5, 6'
        form.save
        expect(subject).to include('は10個以上登録できません。')
      end
    end

    context '1ユーザーにつき101個以上タグを登録しようとするとき' do
      # todoを10個作成
      # あらかじめ1つのtodoに対して10個のタグを登録。（合計100個のタグ）
      before do
        10.times do |_i|
          todo = create(:todo)
          10.times do |i|
            todo.tags.create(name: "user_tag#{i + 1}", user_id: user.id)
          end
        end
      end

      it '[1ユーザー100個までしか登録できません]というエラー文言があること' do
        form.name = '101個目'
        form.save
        expect(subject).to include('は1ユーザー100個までしか登録できません')
      end
    end
  end
end
