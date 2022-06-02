require 'rails_helper'

RSpec.describe "Users::Statuses", type: :request do
  let!(:user) { create(:user) }
  let!(:todo) { create(:todo) }
  let!(:done) { create(:todo, status: 'done') }
  let!(:expired) { create(:todo, status: 'expired') }

  describe "GET /status_todo" do
    context 'ログインしている場合' do
      before do
        sign_in(user)
      end
      it "未完了リスト一覧ページが表示されること" do
        get status_users_mypage_path('todo')
        expect(response.body).to include('未完了リスト一覧')
      end
    end

    context 'ログインしていない場合' do
      it "ログインページにリダイレクトされること" do
        get status_users_mypage_path('todo')
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "GET /status_done" do
        context 'ログインしている場合' do
      before do
        sign_in(user)
      end
      it "完了リスト一覧ページが表示されること" do
        get status_users_mypage_path('done')
        expect(response.body).to include('完了リスト一覧')
      end
    end

    context 'ログインしていない場合' do
      it "ログインページにリダイレクトされること" do
        get status_users_mypage_path('done')
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "GET /status_expired" do
        context 'ログインしている場合' do
      before do
        sign_in(user)
      end
      it "期限切れリスト一覧ページが表示されること" do
        get status_users_mypage_path('expired')
        expect(response.body).to include('期限切れリスト一覧')
      end
    end

    context 'ログインしていない場合' do
      it "ログインページにリダイレクトされること" do
        get status_users_mypage_path('expired')
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
