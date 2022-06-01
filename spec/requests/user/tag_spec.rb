require 'rails_helper'

RSpec.describe "Tag", type: :request do
  let!(:user) { create(:user) }
  let!(:todo) { create(:todo) }
  let!(:tag) { create(:tag) }


  describe "GET /mypage/tags #show" do
    context 'ログインしている場合' do
      before do
        sign_in(user)
      end
      it "returns http success" do
        get users_mypage_tag_path(tag)
        expect(todo.tags).to be_truthy
      end
    end

    context 'ログインしていない場合' do
      it "ログインページにリダイレクトされること" do
        get users_mypage_tag_path(tag)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
