require 'rails_helper'

RSpec.describe "Users::Searches", type: :request do
  let!(:user) { create(:user) }

  describe "GET /users/search" do
    context 'ログインしている場合' do
      before do
        sign_in(user)
      end
      it 'search結果ページが表示されること' do
        get users_search_path(user), params:{keyword: 'MyString'}
        expect(response).to have_http_status(:success)
      end

      context '検索' do
        it '該当のTodoがある場合' do
          get users_search_path(user), params:{keyword: 'MyString'}
          expect(response.body).to include('検索マッチ')
        end

        it '該当のTodoがない場合' do
          get users_search_path(user), params:{keyword: ' '}
          expect(response.body).to include('検索マッチ0')
        end
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
