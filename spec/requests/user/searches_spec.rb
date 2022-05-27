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
      context 'Userモデルを選択した場合' do
        it '完全一致の場合' do
          get users_search_path(user), params:{word: 'word',
                                                range: 'User',
                                                search: 'perfect_match',}
          expect(response.body).to include('User')
          expect(response.body).to include('perfect_match')
        end
        it '前方一致の場合' do
          get users_search_path(user), params:{word: 'word',
                                                range: 'User',
                                                search: 'forward_match',}
          expect(response.body).to include('User')
          expect(response.body).to include('forward_match')
        end
        it '後方一致の場合' do
          get users_search_path(user), params:{word: 'word',
                                                range: 'User',
                                                search: 'backword_match',}
          expect(response.body).to include('User')
          expect(response.body).to include('backword_match')
        end
        it '部分一致の場合' do
          get users_search_path(user), params:{word: 'word',
                                                range: 'User',
                                                search: 'partial_match',}
          expect(response.body).to include('User')
          expect(response.body).to include('partial_match')
        end
      end
      context 'Todoモデルを選択した場合' do
        it '完全一致の場合' do
          get users_search_path(user), params:{word: 'word',
                                                range: 'Todo',
                                                search: 'perfect_match',}
          expect(response.body).to include('Todo')
          expect(response.body).to include('perfect_match')
        end
        it '前方一致の場合' do
          get users_search_path(user), params:{word: 'word',
                                                range: 'Todo',
                                                search: 'forward_match',}
          expect(response.body).to include('Todo')
          expect(response.body).to include('forward_match')
        end
        it '後方一致の場合' do
          get users_search_path(user), params:{word: 'word',
                                                range: 'Todo',
                                                search: 'backword_match',}
          expect(response.body).to include('Todo')
          expect(response.body).to include('backword_match')
        end
        it '部分一致の場合' do
          get users_search_path(user), params:{word: 'word',
                                                range: 'Todo',
                                                search: 'partial_match',}
          expect(response.body).to include('Todo')
          expect(response.body).to include('partial_match')
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
