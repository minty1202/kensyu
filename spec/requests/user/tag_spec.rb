require 'rails_helper'

RSpec.describe "Tag", type: :request do
  let!(:user) { create(:user) }
  let!(:todo) { create(:todo) }
  let!(:tag) { create(:tag) }

  before do
    sign_in(tag.user)
  end

  describe "GET /mypage/tags #show" do
    it "returns http success" do
      get users_mypage_tag_path(tag)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET users/mypage/tags/:id/edit #edit" do
    it "return http success" do
      get edit_users_mypage_tag_path(tag)
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /users/mypage/tags/:id #update" do
    subject { patch users_mypage_tag_path(tag), params: tag_params }

    context "with valid params" do
      let!(:tag_params) do
        { tag: { name: tag.name,
                 user_id: tag.user_id } }
      end

      it "update the tag" do
        expect { subject }.to_not change(Tag, :count)
        expect(tag.reload.name).to eq "MyString"
      end
      it "redirect to users_mypage_url" do
        subject

        expect(response).to redirect_to users_mypage_path
      end
    end

    context "with invalid params" do
      let!(:tag_params) do
        { tag: { name: '' } }
      end

      it "dose not update the tag" do
        subject

        expect { subject }.to_not change(Tag, :count)
      end
    end
  end

  describe "DELETE /users/mypage/tags/:id #delete" do
    subject { delete users_mypage_tag_path(tag) }

    it "delete the tag" do
      expect { subject }.to change(Tag, :count).by(-1)
    end

    it "redirect to users_mypage_url" do
      subject

      expect(response).to redirect_to users_mypage_path
    end
  end
end
