require 'rails_helper'

RSpec.describe "Session", type: :request do
  let!(:admin) { build(:admin) }

  describe "POST /admin/sign_in" do
    it "return http success" do
      post admin_session_path, params: { user: {email: 'test@example.com',
                                        password: '123456' } }
      expect(response).to have_http_status :success
    end
  end

  describe "DELETE /admin/sign_out" do
    before do
      sign_in (admin)
    end
    it "ログアウトできること" do
      delete destroy_admin_session_path(admin)
      expect(response).to redirect_to root_path
      expect(!!session[:user_id]).to_not be_truthy
    end
  end
end
