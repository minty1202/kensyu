require 'rails_helper'

RSpec.describe "Users::Comments", type: :request do
  let!(:user) { create(:user) }
  let!(:todo) { create(:todo) }
  let!(:comment) { create(:comment) }

  describe "POST /users/comments/ #create" do
    context 'ログインしている場合' do
      before do
        sign_in(user)
      end
      context 'コメントの登録が成功する場合' do
        let(:todo_params) { { todo: { title: todo.title,
                                  text: todo.text,
                                  user_id: todo.user},
                                  todo_id: todo.id } }
        let(:comment_params) { { comment: { text: comment.text,
                                  user_id: comment.user,
                                  todo_id: todo.id} } }

        it 'Todoが登録されていること' do
        expect{
          post users_todos_path, params: todo_params
        }.to change(Todo, :count).by 1
        end

        it '有効な値でコメント投稿できること' do
          expect{
            post users_todo_comments_path(todo.id), params: comment_params
          }.to change(Comment, :count).by 1
        end

        it '編集ページにリダイレクトされること' do
          post users_todo_comments_path(todo.id), params: comment_params
          expect(response).to redirect_to edit_users_todo_path(todo)
        end
      end
      context 'コメント登録が失敗する場合' do
        it '無効な値だと登録できないこと' do
          expect {
            post users_todo_comments_path(todo.id), params:{comment: {text: '',
                                          user_id: '',
                                          todo_id: todo.id}}
            }.to_not change(Comment, :count)
        end
      end
    end

    context 'ログインしていない場合' do
      it "ログインページにリダイレクトされること" do
        get edit_users_todo_path(todo)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
