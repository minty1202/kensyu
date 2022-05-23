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
    # puts '---------------------------'
    # puts todo.images.length
    # puts '---------------------------'
    # expect(todo).to_not be_valid
    expect(todo.errors[:images]).to include('は3ファイルまでにしてください')
  end

  it 'すべての値が正常であれば登録できる' do
    expect(todo).to be_valid
  end
end
