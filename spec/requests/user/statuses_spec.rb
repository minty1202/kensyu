require 'rails_helper'

RSpec.describe "Users::Statuses", type: :request do
  let!(:user) { create(:user) }

  describe "GET /status_todo" do
    subject { get status_users_mypage_path('todo') }

    context 'is logged in' do
      before do
        sign_in(user)
      end

      it "returns todo page" do
        subject

        expect(response.body).to include('未完了リスト一覧')
      end
    end

    context 'not logged in' do
      it "redirect to new_user_sesssion_url" do
        subject

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "GET /status_done" do
    subject { get status_users_mypage_path('done') }

    context 'is logged in' do
      before do
        sign_in(user)
      end

      it "returns doen page" do
        subject

        expect(response.body).to include('完了リスト一覧')
      end
    end

    context 'not logged in' do
      it "redirect to new_user_sesssion_url" do
        subject

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "GET /status_expired" do
    subject { get status_users_mypage_path('expired') }

    context 'is logged in' do
      before do
        sign_in(user)
      end

      it "returns expired page" do
        subject

        expect(response.body).to include('期限切れリスト一覧')
      end
    end

    context 'not logged in' do
      it "redirect to new_user_sesssion_url" do
        subject

        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
