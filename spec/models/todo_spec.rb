require 'rails_helper'

RSpec.describe Todo, type: :model do
  let(:todo) {create(:todo) }

  it 'タイトルが必須であること' do
    todo.title = ' '
    expect(todo).to_not be_valid
  end

  it 'タイトルが50字以内であること' do
    todo.title = 'a' * 51
    expect(todo).to_not be_valid
  end

  it 'textが必須であること' do
    todo.text = ' '
    expect(todo).to_not be_valid
  end

  it 'textが140字以内であること' do
    todo.title = 'a' * 141
    expect(todo).to_not be_valid
  end

  it '画像のファイルが3枚以内であること' do
    todo.images.attach(io: File.open('spec/fixtures/files/image/test_image.png'), filename: 'test_image.png', content_type: 'image/png')
    todo.images.attach(io: File.open('spec/fixtures/files/image/test_image.png'), filename: 'test_image.png', content_type: 'image/png')
    todo.images.attach(io: File.open('spec/fixtures/files/image/test_image.png'), filename: 'test_image.png', content_type: 'image/png')
    expect(todo.errors[:images]).to include('は3ファイルまでにしてください')
  end

  it '終了期日が必須であること' do
    todo.limit_date = ' '
    expect(todo).to_not be_valid
  end

  it 'ステータスが必須であること' do
    todo.status = ' '
    expect(todo).to_not be_valid
  end

  it '初期値が未完了であること' do
    expect(todo.status).to eq '未完了'
  end

  it 'すべての値が正常であれば登録できる' do
    expect(todo).to be_valid
  end

  describe 'scope' do
    describe 'search_title' do
      let!(:todo) { create(:todo)}
      subject {Todo.search_title("MyString")}
      it {is_expected.to include todo}
    end
    describe 'search_text' do
      let!(:todo) { create(:todo)}
      subject {Todo.search_text("MyText")}
      it {is_expected.to include todo}
    end
  end

  describe 'save_tagメソッド' do
    let!(:tag) { build(:tag) }
    let!(:todo) { create(:todo)}

    context 'すでにあるタグから他のタグに変える' do
      before do
        tag_one = Tag.create(name: 'tag1', user_id: todo.user.id)
        tag_tow = Tag.create(name: 'tag2', user_id: todo.user.id)
        tag_three = Tag.create(name: 'tag3', user_id: todo.user.id)
        todo.todo_tags.create(tag_id: tag_one.id)
        todo.todo_tags.create(tag_id: tag_tow.id)
        todo.todo_tags.create(tag_id: tag_three.id)
      end

      it 'Tagの数は変わらないこと' do
        expect{todo.save_tag([], [])}.to_not change(Tag, :count)
      end

      it 'TodoTagの数が減ること' do
        expect{todo.save_tag(['tag3'], [])}.to change(TodoTag, :count).by(-2)
      end

    end
    context '新しいタグの保存' do
      it 'Tagの数が増えていること' do
        expect{todo.save_tag([tag.name], [])}.to change(Tag, :count).by(1)
      end
      it 'TodoTagの数が増えていること' do
        expect{todo.save_tag([tag.name], [])}.to change(TodoTag, :count).by(1)
      end
    end
    context 'すでに作成してあるタグの登録' do
      before do
        tag_one = Tag.create(name: 'tag1', user_id: todo.user.id)
        tag_tow = Tag.create(name: 'tag2', user_id: todo.user.id)
        todo.todo_tags.create(tag_id: tag_one.id)
        todo.todo_tags.create(tag_id: tag_tow.id)
      end
      it 'Tagの数は変わらないこと' do
        expect{todo.save_tag(['tag1'], [])}.to_not change(Tag, :count)
      end

      it 'TodoTagの数が変わらないこと' do
        expect{todo.save_tag(['tag_one','tag_tow'], [])}.to_not change(TodoTag, :count)
      end
    end
  end

  describe 'change_statusメソッド' do
    let!(:user) { create(:user) }
    context 'after_commitが実行される' do
      # puts '---------------------'
      # puts '---------------------'
      # p Todo.last
      # let!(:todo) { create(:todo, limit_date: Time.current.yesterday)}
      it '未完了から期限切れになること' do
        # expect{Todo.change_status}.to change{ todo.reload.status }.from('未完了').to('期限切れ')
        expect{Todo.change_status}.to change{ todo.status }.from('未完了').to('期限切れ')
      end
    end
  end

  describe '明日期限の未完了todoを取得して通知する' do
    let!(:todo) { create(:todo, limit_date: Time.current.tomorrow)}
    # モックを作る
    let(:notifier) { double("mock notifier", ping: 'Working as expected')}
    # newメソッドが呼べるようにし、作ったモックを返す
    before do
      allow(Slack::Notifier).to receive(:new).and_return(notifier)
    end

    it 'is success' do
      expect(Todo.notice_expired_todo).to be_truthy
    end

    it { expect(Todo.notice_expired_todo).to eq ('Working as expected') }
  end
end
