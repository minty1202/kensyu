require 'rails_helper'

RSpec.describe "Session", type: :request do
  describe "POST /users/sign_in" do
    it "return http success" do
      post user_session_path
      expect(response).to have_http_status :success
    end
  end

  describe "DELETE /users/sign_out" do
    let!(:user) { create(:user) }
    before do
      sign_in user
    end
    it "ログアウトできること" do
      delete destroy_user_session_path(user)
      expect(response).to have_http_status(204)
    end
  end
end
