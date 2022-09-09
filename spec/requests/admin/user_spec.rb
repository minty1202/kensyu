require 'rails_helper'

RSpec.describe "User", type: :request do
  let!(:admin) { create(:admin) }
  let!(:user) { create(:user) }

  describe "DELETE /admins/dashbord/:id #destroy" do
    subject { delete admins_user_path(user) }

    context 'is logged in' do
      before do
        sign_in(admin)
      end

      it 'delete the user' do
        expect { subject }.to change(User, :count).by(-1)
      end

      it 'redirect to admins_dashbord_url' do
        subject

        expect(response).to redirect_to admins_dashbord_path
      end
    end

    context 'not logged in' do
      it 'redirect to new_admin_session_url' do
        get admins_dashbord_path
        expect(response).to redirect_to new_admin_session_path
      end
    end
  end
end
