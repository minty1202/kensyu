require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) {build(:user) }

  it 'nameが必須であること' do
    user.name = ''
    expect(user).to_not be_valid
  end

  it 'emailが必須であること' do
    user.email = ''
    expect(user).to_not be_valid
  end

  it 'nameは10文字以内であること' do
    user.name = 'a' * 11
    expect(user).to_not be_valid
  end

  it 'passwordが必須であること' do
    user.password = user.password_confirmation = ' ' * 6
    expect(user).to_not be_valid
  end

  it 'passwordが6文字以下は登録できない' do
    user.password = user.password_confirmation = 'a' * 5
    expect(user).to_not be_valid
  end

  it 'passwordが6文字以上であること' do
    user.password = user.password_confirmation = 'a' * 6
    expect(user).to be_valid
  end

  it 'すべての値が正常であれば登録できる' do
    expect(user).to be_valid
  end

end
