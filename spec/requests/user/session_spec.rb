require 'rails_helper'

RSpec.describe "Session", type: :request do
  let!(:user) { build(:user) }
  describe "POST /users/sign_in" do
    it "return http success" do
      post user_session_path, params: { user: {email: 'test@example.com',
                                        password: '123456' } }
      expect(response).to have_http_status :success
    end
  end

  describe "DELETE /users/sign_out" do
    before do
      sign_in(user)
    end
    it "ログアウトできること" do
      delete destroy_user_session_path(user)
      expect(response).to redirect_to root_path
      expect(!!session[:user_id]).to_not be_truthy
    end
  end
end
