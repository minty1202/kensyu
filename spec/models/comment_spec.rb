require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'バリデーション機能テスト' do
    before { comment.valid? }

    describe 'コメントのバリデーションテスト' do
      subject { comment.errors[:text] }

      context 'コメントが空欄のとき' do
        let!(:comment) { build(:comment, text: '') }
        it { is_expected.to be_present }
      end

      context 'コメントが101文字以上のとき' do
        let!(:comment) { build(:comment, text: 'a' * 101) }
        it { is_expected.to be_present }
      end
    end

    context '値が正常のとき' do
      let!(:comment) { build(:comment) }
      it { expect(comment).to be_valid }
    end
  end
end
