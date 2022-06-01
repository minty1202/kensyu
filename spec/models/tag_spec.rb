require 'rails_helper'

RSpec.describe Tag, type: :model do
  let(:tag) {build(:tag) }

  it 'tagが必須であること' do
    tag.name = ' '
    expect(tag).to_not be_valid
  end

  it 'tagが10文字以内であること' do
    tag.name = 'a' * 11
    expect(tag).to_not be_valid
  end

  it 'すべての値が正常であれば登録できる' do
    expect(tag).to be_valid
  end
end
