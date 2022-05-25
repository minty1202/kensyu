require 'rails_helper'

RSpec.describe "User", type: :request do
  let!(:admin) { create(:admin) }
  let!(:user) { create(:user) }

  describe "DELETE /admins/dashbord/:id #destroy" do
    context 'ログインしてる場合' do
      before do
        sign_in(admin)
      end
      it 'userが削除されること'do
        expect {
              delete admins_user_path(user)
          }.to change(User, :count).by(-1)
      end
      it 'dashbprdにリダイレクトされること' do
        delete admins_user_path(user)
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
