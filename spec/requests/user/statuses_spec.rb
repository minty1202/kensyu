require 'rails_helper'

RSpec.describe "Users::Statuses", type: :request do
  let!(:user) { create(:user) }
  let!(:todo) { create(:todo) }
  let!(:done) { create(:todo, status: 'done') }
  let!(:expired) { create(:todo, status: 'expired') }

  describe "GET /mypage #show" do
    context 'ログインしている場合' do
      before do
        sign_in(user)
      end
      it "未完了リスト一覧ページが表示されること" do
        get status_todo_users_mypage_path
        expect(response.body).to include('未完了リスト一覧')
        expect(todo.status).to eq '未完了'
      end
    end

    context 'ログインしていない場合' do
      it "ログインページにリダイレクトされること" do
        get status_todo_users_mypage_path
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
        get status_done_users_mypage_path
        expect(response.body).to include('完了リスト一覧')
        expect(done.status).to eq '完了'
      end
    end

    context 'ログインしていない場合' do
      it "ログインページにリダイレクトされること" do
        get status_done_users_mypage_path
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
        get status_expired_users_mypage_path
        expect(response.body).to include('期限切れリスト一覧')
        expect(expired.status).to eq '期限切れ'
      end
    end

    context 'ログインしていない場合' do
      it "ログインページにリダイレクトされること" do
        get status_expired_users_mypage_path
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
