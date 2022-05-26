require 'rails_helper'

RSpec.describe "Users::Searches", type: :request do
  let!(:user) { create(:user) }

  describe "GET /users/search" do
    context 'ログインしている場合' do
      before do
        sign_in(user)
      end
      it 'search結果ページが表示されること' do
        get users_search_path(user)
        expect(response).to have_http_status(:success)
      end
    end

    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトされること' do
        get users_search_path
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
