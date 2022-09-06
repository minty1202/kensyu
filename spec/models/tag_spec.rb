require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe 'タグのバリデーション機能テスト' do
    before { tag.valid? }

    describe 'タグのバリデーションテスト' do
      subject { tag.errors[:name] }

      context 'タグが12文字以上のとき' do
        let!(:tag) { build(:tag, name: 'a' * 12) }
        it { is_expected.to be_present }
      end
    end

    context '値が正常のとき' do
      let!(:tag) { build(:tag) }
      it { expect(tag).to be_valid }
    end
  end
end
