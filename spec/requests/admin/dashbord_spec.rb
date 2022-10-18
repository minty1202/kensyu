require 'rails_helper'

RSpec.describe "Admins::Dashbord", type: :request do
  let!(:admin) { create(:admin) }

  describe "GET /admins_dashbord #show" do
    subject { get admins_dashbord_path }

    context 'ログインしている場合' do
      before do
        sign_in(admin)
      end

      it "returns http success" do
        subject

        expect(response).to have_http_status(:success)
      end
    end

    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトされること' do
        subject

        expect(response).to redirect_to new_admin_session_path
      end
    end
  end
end
