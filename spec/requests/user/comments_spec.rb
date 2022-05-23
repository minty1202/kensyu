require 'rails_helper'

RSpec.describe "Users::Comments", type: :request do
  let!(:user) { create(:user) }
  let!(:todo) { create(:todo) }

  describe "POST /users/comments/ #create" do
    context 'ログインしている場合' do
      before do
        sign_in(user)
      end
      context 'コメントの登録が成功する場合' do
        let(:comment_params) { { comment: { comment_text: 'test',
                                  user_id: 1,
                                  todo_id: 1} } }

        it '有効な値で登録できること' do
          expect{
            post users_todo_comments_path(todo), params: comment_params
          }.to change(Comment, :count).by 1
        end

        it '編集ページにリダイレクトされること' do
          post users_todo_comments_path(comment_params)
          expect(response).to redirect_to edit_users_todo_path(todo)
        end
      end
      context 'コメント登録が失敗する場合' do
        it '無効な値だと登録できないこと' do
          expect {
            post users_todo_comments_path, params:{comment: {comment_text: '',
                                          user_id: '',
                                          todo_id: ''}}
            }.to_not change(Comment, :count)
        end
      end
    end

    context 'ログインしていない場合' do
      it "ログインページにリダイレクトされること" do
        post users_todo_comments_path
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
