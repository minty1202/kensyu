require 'rails_helper'

RSpec.describe Admin, type: :model do
  describe 'バリデーション機能テスト' do
    before { admin.valid? }

    context '値が正常のとき' do
      let!(:admin) { build(:admin) }
      it { expect(admin).to be_valid }
    end

    describe 'メールバリデーションテスト' do
      subject { admin.errors[:email] }

      context 'メールが空欄のとき' do
        let!(:admin) { build(:admin, email: '') }
        it { is_expected.to be_present }
      end
    end

    describe 'パスワードバリデーションテスト' do
      subject { admin.errors[:password] }

      context 'パスワードが空欄のとき' do
        let!(:admin) { build(:admin, password: '') }
        it { is_expected.to be_present }
      end

      context 'パスワードが5文字以下のとき' do
        let!(:admin) { build(:admin, password: 'a' * 5) }
        it { is_expected.to be_present }
      end
    end
  end
end
