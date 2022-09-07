require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション機能テスト' do
    before { user.valid? }

    context '値が正常のとき' do
      let!(:user) { build(:user) }
      it { expect(user).to be_valid }
    end

    describe '名前のバリデーションテスト' do
      subject { user.errors[:name] }

      context '名前が空欄のとき' do
        let!(:user) { build(:user, name: '') }
        it { is_expected.to be_present }
      end

      context '名前が11文字以上のとき' do
        let!(:user) { build(:user, name: 'a' * 11) }
        it { is_expected.to be_present }
      end
    end

    describe 'パスワードのバリデーションテスト' do
      subject { user.errors[:password] }

      context 'パスワードが空欄のとき' do
        let!(:user) { build(:user, password: '') }
        it { is_expected.to be_present }
      end

      context 'パスワードが5文字以下のとき' do
        let(:user) { build(:user, password: 'a' * 5) }
        it { is_expected.to be_present }
      end
    end
  end
end
