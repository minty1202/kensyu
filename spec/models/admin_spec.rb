require 'rails_helper'

RSpec.describe Admin, type: :model do
  let(:admin) { build(:admin) }

  it 'emailが必須であること' do
    admin.email = ''
    expect(admin).to_not be_valid
  end

  it 'passwordが必須であること' do
    admin.password = admin.password_confirmation = ' ' * 6
    expect(admin).to_not be_valid
  end

  it 'passwordが6文字以下は登録できない' do
    admin.password = admin.password_confirmation = 'a' * 5
    expect(admin).to_not be_valid
  end

  it 'passwordが6文字以上であること' do
    admin.password = admin.password_confirmation = 'a' * 6
    expect(admin).to be_valid
  end

  it { expect(admin).to be_valid }
end
