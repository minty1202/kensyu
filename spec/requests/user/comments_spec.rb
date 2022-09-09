require 'rails_helper'

RSpec.describe "Users::Comments", type: :request do
  let!(:user) { create(:user) }
  let!(:todo) { create(:todo) }
  let!(:comment) { create(:comment) }
  let!(:tag) { create(:tag) }
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

    context 'with valid params' do
      let!(:comment_params) do
        { comment: { text: comment.text,
                     user_id: comment.user,
                     todo_id: todo.id } }
      end

      it 'create a new Todo' do
        expect do
          post users_todos_path, params: todo_params
        end.to change(Todo, :count).by(1)
      end

      it 'create a new Comment' do
        expect { subject }.to change(Comment, :count).by(1)
      end

      it 'redirect to eidt_users_todo_url' do
        subject

        expect(response).to redirect_to edit_users_todo_path(todo)
      end
    end

    context 'with invalid params' do
      let!(:comment_params) do
        { comment: { text: '' } }
      end

      it 'create a new Todo' do
        expect do
          post users_todos_path, params: todo_params
        end.to change(Todo, :count).by(1)
      end

      xit 'dose not create a new comment' do
        expect { subject }.not_to change(Comment, :count)
      end
    end
  end

  context 'not logged in' do
    it "redirect to new_user_session_url" do
      get edit_users_todo_path(todo)
      expect(response).to redirect_to new_user_session_path
    end
  end
end
