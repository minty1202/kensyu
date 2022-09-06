require 'rails_helper'

RSpec.describe Todo, type: :model do
  describe 'バリデーション機能テスト' do
    before { todo.valid? }

    describe 'タイトルバリデーションテスト' do
      subject { todo.errors[:title] }

      context 'TODOのタイトルが空欄のとき' do
        let!(:todo) { build(:todo, title: '') }
        it { is_expected.to be_present }
      end

      context 'TODOのタイトルが51文字以上のとき' do
        let!(:todo) { build(:todo, title: 'a' * 51) }
        it { is_expected.to be_present }
      end
    end

    describe 'テキストバリデーションテスト' do
      subject { todo.errors[:text] }

      context 'テキストが空欄のとき' do
        let!(:todo) { build(:todo, text: '') }
        it { is_expected.to be_present }
      end

      context 'テキストが141文字以上のとき' do
        let!(:todo) { build(:todo, text: 'a' * 141) }
        it { is_expected.to be_present }
      end
    end

    describe '画像のバリデーションテスト' do
      subject { todo.errors[:images] }

      context '画像が4枚以上のとき' do
        let!(:todo) do
          build(:todo) do |f|
            4.times do
              f.images.attach(io: File.open('spec/fixtures/files/image/test_image.png'), filename: 'test_image.png', content_type: 'image/png')
            end
          end
        end

        it { is_expected.to be_present }
      end
    end

    describe '終了期限のバリデーションテスト' do
      subject { todo.errors[:limit_date] }

      context '終了期限が空欄のとき' do
        let!(:todo) { build(:todo, limit_date: '') }
        it { is_expected.to be_present }
      end
    end

    describe 'ステータスのバリデーションテスト' do
      subject { todo.errors[:status] }

      context 'ステータスが空欄のとき' do
        let!(:todo) { build(:todo, status: '') }
        it { is_expected.to be_present }
      end
    end

    context '値が正常のとき' do
      let!(:todo) { build(:todo) }
      it { expect(todo).to be_valid }
    end
  end

  describe 'スコープの機能テスト' do
    let!(:todo) { create(:todo) }

    describe 'タイトル検索' do
      subject { Todo.search_title("MyString") }
      it { is_expected.to include todo }
    end

    describe 'テキスト検索' do
      subject { Todo.search_text("MyText") }
      it { is_expected.to include todo }
    end
  end

  describe 'save_tagメソッド' do
    let!(:tag) { build(:tag) }
    let!(:todo) { create(:todo) }
    before do
      tag_one = Tag.create(name: 'tag1', user_id: todo.user.id)
      tag_tow = Tag.create(name: 'tag2', user_id: todo.user.id)
      todo.todo_tags.create(tag_id: tag_one.id)
      todo.todo_tags.create(tag_id: tag_tow.id)
    end

    context '新しいタグを登録するとき' do
      it 'タグの数が増えていること' do
        expect { todo.save_tag([tag.name], []) }.to change(Tag, :count).by(1)
      end
    end

    context 'すでにあるタグと同じタグを登録するとき' do
      it 'タグの数は変わらないこと' do
        expect { todo.save_tag(['tag1'], []) }.to_not change(Tag, :count)
      end
    end
  end

  describe 'change_statusメソッド' do
    let!(:user) { create(:user) }
    let!(:todo) { create(:todo, :todo_change_status, :skip_validate) }

    context 'after_commitが実行されるとき' do
      it '未完了から期限切れになること' do
        expect { Todo.change_status }.to change { todo.reload.status }.from('未完了').to('期限切れ')
      end
    end
  end

  describe 'notice_expired_todoメソッド' do
    # モックを作る
    let!(:notifier) { double("mock notifier", ping: 'Working as expected') }

    # newメソッドが呼べるようにし、作ったモックを返す
    before do
      allow(Slack::Notifier).to receive(:new).and_return(notifier)
    end

    context '明日期限の未完了todoを取得して通知するとき' do
      let!(:todo) { create(:todo, limit_date: Time.current.tomorrow) }
      it { expect(Todo.notice_expired_todo).to eq('Working as expected') }
    end
  end
end
