require 'rails_helper'

RSpec.describe "Users::Comments", type: :request do
  let!(:user) { create(:user) }
  let!(:todo) { create(:todo) }
  let!(:comment) { create(:comment) }
  let!(:tag) { create(:tag) }

  describe "POST /users/comments/ #create" do
    context 'ログインしている場合' do
      before do
        sign_in(user)
      end
      context 'コメントの登録が成功する場合' do
        let(:todo_params) do
          { todo: { title: todo.title,
                    text: todo.text,
                    user_id: todo.user,
                    name: tag.name,
                    status: todo.status,
                    limit_date: Time.current },
            todo_id: todo.id }
        end
        let(:comment_params) do
          { comment: { text: comment.text,
                       user_id: comment.user,
                       todo_id: todo.id } }
        end

        it 'Todoが登録されていること' do
          expect do
            post users_todos_path, params: todo_params
          end.to change(Todo, :count).by 1
        end

        it '有効な値でコメント投稿できること' do
          expect do
            post users_todo_comments_path(todo.id), params: comment_params
          end.to change(Comment, :count).by 1
        end

        it '編集ページにリダイレクトされること' do
          post users_todo_comments_path(todo.id), params: comment_params
          expect(response).to redirect_to edit_users_todo_path(todo)
        end
      end
      context 'コメント登録が失敗する場合' do
        let(:todo_params) do
          { todo: { title: todo.title,
                    text: todo.text,
                    user_id: todo.user,
                    name: tag.name,
                    status: todo.status,
                    limit_date: Time.current },
            todo_id: todo.id }
        end
        let(:comment_params2) do
          { comment: { text: '',
                       user_id: '',
                       todo_id: todo.id } }
        end

        it 'Todoが登録されていること' do
          expect do
            post users_todos_path, params: todo_params
          end.to change(Todo, :count).by 1
        end
        xit '無効な値だと登録できないこと' do
          expect do
            post users_todo_comments_path(todo.id), params: comment_params2
          end.to_not change(Comment, :count)
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
