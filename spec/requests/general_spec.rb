require 'rails_helper'

RSpec.describe "Generals", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/general/index"
      expect(response).to have_http_status(:success)
    end
  end

end
