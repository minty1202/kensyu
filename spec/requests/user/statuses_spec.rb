require 'rails_helper'

RSpec.describe "Users::Statuses", type: :request do
  let!(:user) { create(:user) }

  describe "GET /status_todo" do
    subject { get status_users_mypage_path('todo') }

    context 'ログインしている場合' do
      before do
        sign_in(user)
      end

      it "未完了Todoページが表示されること" do
        subject

        expect(response.body).to include('未完了リスト一覧')
      end
    end

    context 'ログインしていない場合' do
      it "ログインページにリダイレクトされること" do
        subject

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "GET /status_done" do
    subject { get status_users_mypage_path('done') }

    context 'ログインしている場合' do
      before do
        sign_in(user)
      end

      it "完了Todoページが表示されること" do
        subject

        expect(response.body).to include('完了リスト一覧')
      end
    end

    context 'ログインしていない場合' do
      it "ログインページにリダイレクトされること" do
        subject

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "GET /status_expired" do
    subject { get status_users_mypage_path('expired') }

    context 'ログインしている場合' do
      before do
        sign_in(user)
      end

      it "期限切れTodoページが表示されること" do
        subject

        expect(response.body).to include('期限切れリスト一覧')
      end
    end

    context 'ログインしていない場合' do
      it "ログインページにリダイレクトされること" do
        subject

        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
