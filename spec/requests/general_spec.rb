require 'rails_helper'

RSpec.describe "General", type: :request do
  let!(:user) { create(:user) }
  let!(:todo) { create(:todo) }

  describe "GET /index" do
    it "returns http success" do
      get root_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET users/mypage " do
    context 'is logged in' do
      before do
        sign_in(user)
      end

      it 'returns http success' do
        get users_mypage_path(todo.user)
        expect(response).to have_http_status(:success)
      end
    end

    context 'not logged in' do
      it 'redirect to new_user_session_url' do
        get users_mypage_path
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "GET users/todos/:id/edit #edit" do
    context 'is logged in' do
      before do
        sign_in(todo.user)
      end

      it "return http success" do
        get edit_users_todo_path(todo)
        expect(response).to have_http_status(:success)
      end
    end

    context 'not logged in' do
      it "redirect to new_user_session_url'" do
        get edit_users_todo_path(todo)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
