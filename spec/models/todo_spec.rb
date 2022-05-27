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

  it '画像のファイルが3枚以内であること' do
    todo.images.attach(io: File.open('spec/fixtures/files/image/test_image.png'), filename: 'test_image.png', content_type: 'image/png')
    todo.images.attach(io: File.open('spec/fixtures/files/image/test_image.png'), filename: 'test_image.png', content_type: 'image/png')
    todo.images.attach(io: File.open('spec/fixtures/files/image/test_image.png'), filename: 'test_image.png', content_type: 'image/png')
    expect(todo.errors[:images]).to include('は3ファイルまでにしてください')
  end

  it 'すべての値が正常であれば登録できる' do
    expect(todo).to be_valid
  end

  describe 'lookforメソッド' do
  let!(:todo2) {create(:todo, title: 'todo2') }

    context '完全一致で検索した場合' do
    let(:perfect_match_params) { {search: 'perfect_match'} }

      it 'todoを取得出来ること ' do
        expect(Todo.lookfor(perfect_match_params, todo.title)).to include(todo)
      end
      it 'todo2を取得出来ないこと ' do
        expect(Todo.lookfor(perfect_match_params, todo.title)).to_not include(todo2.title)
      end
    end
    context '前方一致で検索した場合' do
    let(:forward_match_params) { {search: 'forward_match'} }

      it 'todoを取得出来ること ' do
        expect(Todo.lookfor(forward_match_params, todo.title)).to include(todo)
      end
      it 'todo2を取得出来ないこと ' do
        expect(Todo.lookfor(forward_match_params, todo.title)).to_not include(todo2.title)
      end
    end
    context '後方一致で検索した場合' do
    let(:backword_match_params) { {search: 'backword_match'} }

      it 'todoを取得出来ること ' do
        expect(Todo.lookfor(backword_match_params, todo.title)).to include(todo)
      end
      it 'todo2を取得出来ないこと ' do
        expect(Todo.lookfor(backword_match_params, todo.title)).to_not include(todo2.title)
      end
    end
    context '部分一致で検索した場合' do
    let(:partial_match_params) { {search: 'partial_match'} }

      it 'todoを取得出来ること ' do
        expect(Todo.lookfor(partial_match_params, todo.title)).to include(todo)
      end
      it 'todo2を取得出来ないこと ' do
        expect(Todo.lookfor(partial_match_params, todo.title)).to_not include(todo2.title)
      end
    end
  end
end
