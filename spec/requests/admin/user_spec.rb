require 'rails_helper'

RSpec.describe "User", type: :request do
  let!(:admin) { create(:admin) }
  let!(:user) { create(:user) }

  describe "DELETE /admins/dashbord/:id #destroy" do
    subject { delete admins_user_path(user) }

    context 'ログインしている場合' do
      before do
        sign_in(admin)
      end

      it 'ユーザーを削除できること' do
        expect { subject }.to change(User, :count).by(-1)
      end

      it 'ダッシュボードにリダイレクトされること' do
        subject

        expect(response).to redirect_to admins_dashbord_path
      end
    end

    context 'ログインしていない場合' do
      it '管理者ログインページにリダイレクトされること' do
        get admins_dashbord_path
        expect(response).to redirect_to new_admin_session_path
      end
    end
  end
end
