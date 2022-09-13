require 'rails_helper'

RSpec.describe "Users::Comments", type: :request do
  let!(:user) { create(:user) }
  let!(:todo) { create(:todo) }
  let(:todo_params) do
    { todo: { title: todo.title,
              text: todo.text,
              user_id: todo.user,
              name: tag.name,
              status: todo.status,
              limit_date: Time.current },
      todo_id: todo.id }
  end

  describe "POST #create" do
    subject { post users_todo_comments_path(todo.id), params: comment_params }

    before do
      sign_in(user)
    end

    context '有効な値の場合' do
      let!(:comment_params) do
        { comment: { text: 'commnet',
                     user_id: todo.user,
                     todo_id: todo.id } }
      end

      it 'コメントを新しく作れること' do
        expect { subject }.to change(Comment, :count).by(1)
      end

      it 'Todo詳細ページにリダイレクトされること' do
        subject

        expect(response).to redirect_to users_todo_path(todo)
      end
    end

    context '無効な値の場合' do
      let!(:comment_params) do
        { comment: { text: ' ',
                     user_id: todo.user,
                     todo_id: todo.id } }
      end

      it 'コメントを新しく作れないこと' do
        expect { subject }.not_to change(Comment, :count)
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
