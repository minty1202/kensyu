require 'rails_helper'

RSpec.describe "User", type: :request do
  let!(:user) { create(:user) }
  before do
    sign_in(user)
  end

  describe "GET /mypage #show" do
    it "returns http success" do
      get users_mypage_path(user)
      expect(response).to have_http_status(:success)
    end
  end
end
