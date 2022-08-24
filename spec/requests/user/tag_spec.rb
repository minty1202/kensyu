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
        expect(response).to have_http_status(:success)
      end
    end

    context 'ログインしていない場合' do
      it "ログインページにリダイレクトされること" do
        get users_mypage_tag_path(tag)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "GET users/mypage/tags/:id/edit #edit" do
    context 'ログインしている場合' do
      before do
        sign_in(tag.user)
      end
      it "return http success" do
        get edit_users_mypage_tag_path(tag)
        expect(response).to have_http_status(:success)
      end
    end
    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        get edit_users_mypage_tag_path(tag)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "PATCH /users/mypage/tags/:id #update" do
    let!(:tag_params) do
      { tag: { name: tag.name,
               user_id: tag.user_id } }
    end
    context "更新が失敗する場合" do
      it "無効な値だと更新されないこと" do
        expect do
          patch users_mypage_tag_path(tag), params: { tag_params: { name: '',
                                                                    user_id: '' } }
        end.to_not change(Tag, :count)
      end
    end
    context "更新成功する場合" do
      before do
        sign_in(tag.user)
      end

      it "更新されること" do
        expect do
          patch users_mypage_tag_path(tag), params: tag_params
        end.to_not change(Tag, :count)
        expect(tag.reload.name).to eq "MyString"
      end
      it "マイページにリダイレクトされること" do
        patch users_mypage_tag_path(tag), params: tag_params
        expect(response).to redirect_to users_mypage_path
        expect(flash[:success]).to be_truthy
      end
    end
    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        patch users_mypage_tag_path(tag)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "DELETE /users/mypage/tags/:id #delete" do
    context "ログインしている場合" do
      before do
        sign_in(tag.user)
      end

      context "削除が成功する場合" do
        it "タグが削除されること" do
          expect do
            delete users_mypage_tag_path(tag)
          end.to change(Tag, :count).by(-1)
        end
        it "マイページにリダイレクトされること" do
          delete users_mypage_tag_path(tag)
          expect(response).to redirect_to users_mypage_path
          expect(flash[:success]).to be_truthy
        end
      end
    end
    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        delete users_mypage_tag_path(tag)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
