require 'rails_helper'

RSpec.describe "Dashbord", type: :request do
  let!(:admin) { create(:admin) }
  let!(:user) { create(:user) }

  describe "GET /admins_dashbord#show" do
    context 'ログインしている場合' do
      before do
        sign_in(admin)
      end
      it "returns http success" do
        get admins_dashbord_path
        expect(response).to have_http_status(:success)
      end
    end

    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトされること' do
        get admins_dashbord_path
        expect(response).to redirect_to new_admin_session_path
      end
    end

  end

  describe "DELETE /admins/dashbord/:id #destroy" do
    context 'ログインしてる場合' do
      before do
        sign_in(admin)
      end
      it 'userが削除されること'do
        expect {
              delete admins_dashbord_path(user)
          }.to change(User, :count).by(-1)
      end
      it 'dashbprdにリダイレクトされること' do
        delete admins_dashbord_path(user)
        expect(response).to redirect_to admins_dashbord_path
      end
    end
    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトされること' do
        get admins_dashbord_path
        expect(response).to redirect_to new_admin_session_path
      end
    end
  end

end
