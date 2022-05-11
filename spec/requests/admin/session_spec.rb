require 'rails_helper'

RSpec.describe "Session", type: :request do
  describe "POST /admin/sign_in" do
    it "return http success" do
      post admin_session_path
      expect(response).to have_http_status :success
    end
  end

  describe "DELETE /admin/sign_out" do
    let!(:user) { create(:user) }
    before do
      sign_in user
    end
    it "ログアウトできること" do
      delete destroy_admin_session_path(user)
      expect(!!session.id).to_not be_truthy
    end
  end
end
