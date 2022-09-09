require 'rails_helper'

RSpec.describe "Admin", type: :request do
  describe 'GET /admin/sign_up' do
    it "returns http success" do
      get new_admin_registration_path
      expect(response).to have_http_status :success
    end
  end

  describe 'POST /admin/registrations #create' do
    subject { post admin_registration_path, params: admin_params }

    context 'with valid params' do
      let!(:admin_params) do
        { admin: { email: 'admin@example.com',
                   password: '123456' } }
      end

      it 'create a new admin' do
        expect { subject }.to change(Admin, :count).by 1
      end

      it 'is logged in' do
        subject

        expect(!session.id.nil?).to be_truthy
      end
    end

    context 'with invalid params' do
      let!(:admin_params) do
        { admin: { email: '',
                   password: '' } }
      end

      it 'dose not create a new admin' do
        expect { subject }.to_not change(Admin, :count)
      end
    end
  end
end
