require 'rails_helper'

RSpec.describe "Session", type: :request do
  let!(:admin) { create(:admin) }
  before do
    sign_in (admin)
  end

  describe "POST /admin/sign_in" do
    it "return http success" do
      post admin_session_path, params: { admin: {email: 'test@example.com',
                                        password: '123456' } }
      expect(response).to have_http_status(302)
    end
  end

  describe "DELETE /admin/sign_out" do
    it "ログアウトできること" do
      delete destroy_admin_session_path(admin)
      expect(response).to have_http_status(204)
    end
  end
end
