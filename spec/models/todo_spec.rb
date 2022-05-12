require 'rails_helper'

RSpec.describe Todo, type: :model do
  let(:todo) {build(:todo) }

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

  it 'すべての値が正常であれば登録できる' do
    expect(todo).to be_valid
  end
end
