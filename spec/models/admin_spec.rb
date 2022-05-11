require 'rails_helper'

RSpec.describe Admin, type: :model do
  let(:user) {build(:user) }

  it 'emailが必須であること' do
    user.email = ''
    expect(user).to_not be_valid
  end

  it 'emailは重複して登録できないこと' do
    duplicate_user = user.dup
    duplicate_user.email = user.email
    user.save
    expect(duplicate_user).to_not be_valid
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
end
