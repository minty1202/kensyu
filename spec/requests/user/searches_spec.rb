require 'rails_helper'

RSpec.describe "Users::Searches", type: :request do
  let!(:user) { create(:user) }

  describe "GET /#search" do
    subject { get users_search_path(user), params: { keyword: 'MyString' } }

    context 'is logged in' do
      before do
        sign_in(user)
      end

      it 'returns http success' do
        subject

        expect(response).to have_http_status(:success)
      end

      it 'found search results' do
        subject

        expect(response.body).to include('検索マッチ')
      end

      it 'not be found search results ' do
        get users_search_path(user), params: { keyword: ' ' }
        expect(response.body).to include('検索マッチ0')
      end
    end

    context 'not logged in' do
      it 'redirect to new_user_session_url' do
        get users_search_path
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
