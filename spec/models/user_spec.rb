require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { User.new(name: 'Example User', email: 'user@example.com',password: "foobar", password_confirmation: "foobar") }

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

  it 'emailは重複して登録できないこと' do
    duplicate_user = user.dup
    duplicate_user.email = user.email.upcase
    user.save
    expect(duplicate_user).to_not be_valid
  end

  it 'passwordが必須であること' do
    user.password = user.password_confirmation = ' ' * 6
    expect(user).to_not be_valid
  end

  it 'passwordが6文字以上であること' do
    user.password = user.password_confirmation = 'a' * 5
    expect(user).to_not be_valid
  end
end
