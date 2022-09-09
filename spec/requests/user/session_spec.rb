require 'rails_helper'

RSpec.describe "Session", type: :request do
  let!(:user) { create(:user) }
  before do
    sign_in(user)
  end
  describe "POST /users/sign_in" do
    it "return http success" do
      post user_session_path, params: { user: { email: 'test@example.com',
                                                password: '123456' } }
      expect(response).to have_http_status(302)
    end
  end

  describe "DELETE /users/sign_out" do
    it "success to logout" do
      delete destroy_user_session_path(user)
      expect(response).to have_http_status(204)
    end
  end
end
