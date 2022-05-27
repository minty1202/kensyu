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

  describe 'lookforメソッド' do
  let!(:user) {create(:user) }
  let!(:user2) {create(:user, name: 'user2') }

    context '完全一致で検索した場合' do
    let(:perfect_match_params) { {search: 'perfect_match'} }

      it 'userを取得出来ること ' do
        expect(User.lookfor(perfect_match_params, user.name)).to include(user)
      end
      it 'user2を取得出来ないこと ' do
        expect(User.lookfor(perfect_match_params, user.name)).to_not include(user2.name)
      end
    end
    context '前方一致で検索した場合' do
    let(:forward_match_params) { {search: 'forward_match'} }

      it 'userを取得出来ること ' do
        expect(User.lookfor(forward_match_params, user.name)).to include(user)
      end
      it 'user2を取得出来ないこと ' do
        expect(User.lookfor(forward_match_params, user.name)).to_not include(user2.name)
      end
    end
    context '後方一致で検索した場合' do
    let(:backword_match_params) { {search: 'backword_match'} }

      it 'userを取得出来ること ' do
        expect(User.lookfor(backword_match_params, user.name)).to include(user)
      end
      it 'user2を取得出来ないこと ' do
        expect(User.lookfor(backword_match_params, user.name)).to_not include(user2.name)
      end
    end
    context '部分一致で検索した場合' do
    let(:partial_match_params) { {search: 'partial_match'} }

      it 'userを取得出来ること ' do
        expect(User.lookfor(partial_match_params, user.name)).to include(user)
      end
      it 'user2を取得出来ないこと ' do
        expect(User.lookfor(partial_match_params, user.name)).to_not include(user2.name)
      end
    end
  end
end
