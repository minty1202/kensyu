require 'rails_helper'

RSpec.describe "Todos", type: :request do
  let!(:user) { create(:user) }

  describe "GET /todos/new #new" do
    context 'ログインしている場合' do
      before do
        sign_in(user)
      end
      it "return http success" do
        get new_users_todo_path(user)
        expect(response).to have_http_status(:success)
      end
    end
    context 'ログインしていない場合' do
      it "ログインページにリダイレクトされること" do
        get new_users_todo_path
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "POST users/todos #create" do
    context 'ログインしている場合' do
      before do
        sign_in(user)
      end
      context '登録が失敗する場合' do
        it '無効な値だと登録されないこと' do
          expect {
            post users_todos_path, params:{todo: {title: '',
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
          post users_todos_path, params: todo_params
        }.to change(Todo, :count).by 1
        end
        it "ユーザー詳細ページにリダイレクトされること" do
          post users_todos_path(todo_params)
          expect(response).to redirect_to users_mypage_path
          expect(flash[:success]).to be_truthy
        end
      end
    end
    context 'ログインしていない場合' do
      it "ログインページにリダイレクトされること" do
        post users_todos_path
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "GET users/todos/:id/edit #edit" do
    let!(:todo) { create(:todo) }
    context 'ログインしている場合' do
      before do
        sign_in(user)
      end
      it "return http success" do
        get edit_users_todo_path(todo)
        expect(response).to have_http_status(:success)
      end
    end
    context 'ログインしていない場合' do
      it "ログインページにリダイレクトされること" do
        get edit_users_todo_path(todo)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "PATCH /todos #update" do
    let!(:todo) { create(:todo) }
    context 'ログインしている場合' do
      before do
        sign_in(user)
      end
      context '更新が失敗する場合' do
        it '無効な値だと更新されないこと' do
          expect {
            patch users_todo_path(todo), params:{todo: {title: '',
                                          text: '',
                                          user_id: ''}}
            }.to_not change(Todo, :count)
        end
      end
      context '更新が成功する場合' do
        let(:todo_params) { { todo: { title: 'test',
                                  text: 'hogehogehoge',
                                  user_id: 1} } }
        it '更新されること' do
          expect{
            patch users_todo_path(todo), params: todo_params
          }.to_not change(Todo, :count)
          expect(todo.reload.title).to eq 'test'
        end
        it "ユーザー詳細ページにリダイレクトされること" do
          patch users_todo_path(todo), params: todo_params
          expect(response).to redirect_to users_mypage_path
          expect(flash[:success]).to be_truthy
        end
      end
    end
    context 'ログインしていない場合' do
      it "ログインページにリダイレクトされること" do
        patch users_todo_path(todo)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
