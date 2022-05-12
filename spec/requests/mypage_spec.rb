require 'rails_helper'

RSpec.describe "Mypages", type: :request do
  let!(:user) { create(:user) }

  describe "GET /mypage #show" do
    it "returns http success" do
      get mypage_path(user)
      expect(response).to have_http_status(:success)
    end
  end
end
