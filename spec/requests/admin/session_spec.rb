require 'rails_helper'

RSpec.describe "Session", type: :request do
  let!(:admin) { create(:admin) }
  before do
    sign_in(admin)
  end

  describe "POST /admin/sign_in" do
    subject { post admin_session_path, params: { admin: { email: admin.email, password: admin.password } } }

    it 'ログイン状態であること' do
      subject

      expect(session.id).not_to be_nil
    end

    it "ダッシュボードにリダイレクトされること" do
      expect(subject).to redirect_to admins_dashbord_path(admin)
    end
  end

  describe "DELETE /admin/sign_out" do
    it "ログアウトが出来ること" do
      delete destroy_admin_session_path(admin)
      expect(response).to have_http_status(204)
    end
  end
end
