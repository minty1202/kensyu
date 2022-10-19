require 'rails_helper'

RSpec.describe "User", type: :request do
  let!(:user) { create(:user) }

  describe "GET #show" do
    context 'ログインしている場合' do
      before do
        sign_in(user)
      end

      it "returns http success" do
        get users_mypage_path(user)
        expect(response).to have_http_status(:success)
      end
    end

    context 'ログインしていない場合' do
      it "ログインページにリダイレクトされること" do
        get users_mypage_path
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "POST #done" do
    subject { post done_users_mypage_path(todo.id), params: todo_params, headers: }

    before do
      sign_in(user)
    end

    let(:todo) { create(:todo, user_id: user.id) }
    let(:todo_params) do
      { todo: { title: todo.title,
                text: todo.text,
                user_id: user.id,
                limit_date: todo.limit_date,
                status: '完了' } }
    end
    let(:headers) { { 'HTTP_REFERER' => referer } }
    let!(:referer) { "/users/mypage" }

    it 'ステータスが未完了から完了に変わること' do
      expect { subject }.to change { todo.reload.status }.from('未完了').to('完了')
    end

    it 'リファラーにリダイレクトされること' do
      subject

      expect(response).to redirect_to redirect_to referer
    end
  end
end
