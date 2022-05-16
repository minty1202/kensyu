require 'rails_helper'

RSpec.describe "Todos", type: :request do
  let!(:user) { create(:user) }
  before do
    sign_in(user)
  end

  describe "GET /todo/new #new" do
    it "return http success" do
      get new_users_todo_path(user)
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /todo #create" do
    context '登録が失敗する場合' do
      it '無効な値だと登録されないこと' do
        expect {
          post users_todo_path, params:{todo: {title: '',
                                        text: '',
                                        user_id: ''}}
          }.to_not change(Todo, :count)
      end
    end

    context '登録が成功する場合' do
      let(:todo_params) { { todo: { title: 'test',
                                text: 'hogehogehoge',
                                user_id: 1} } }
      # let!(:todo) { create(:todo) }
      it '登録されること' do
      expect{
        post users_todo_path, params: todo_params
      }.to change(Todo, :count).by 1
      end

      it "ユーザー詳細ページにリダイレクトされること" do
        post users_todo_path(todo_params)
        expect(response).to redirect_to users_mypage_path
        expect(flash[:success]).to be_truthy
      end
    end
  end
end
