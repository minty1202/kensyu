require 'rails_helper'

RSpec.describe "Session", type: :request do
  let!(:user) { create(:user) }
  before do
    sign_in(user)
  end
  describe "POST /users/sign_in" do
    subject { post user_session_path, params: { user: { email: user.email, password: user.password } } }

    it 'ログイン状態であること' do
      subject

      expect(session.id).not_to be_nil
    end

    it "マイページにリダイレクトされること" do
      expect(subject).to redirect_to users_mypage_path(user)
    end
  end

  describe "DELETE /users/sign_out" do
    it "ログアウトが出来ること" do
      delete destroy_user_session_path(user)
      expect(response).to have_http_status(204)
    end
  end
end
