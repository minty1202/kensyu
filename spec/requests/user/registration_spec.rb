require 'rails_helper'

RSpec.describe "User", type: :request do
  describe 'GET sign_up' do
    it "returns http success" do
      get new_user_registration_path
      expect(response).to have_http_status :success
    end
  end

  describe 'POST #create' do
    subject { post user_registration_path, params: user_params }

    context 'with valid params' do
      let!(:user_params) do
        { user: { name: 'test',
                  email: 'test@example.com',
                  password: '123456',
                  password_confirmation: '123456' } }
      end

      it 'create a new user ' do
        expect { subject }.to change(User, :count).by(1)
      end

      it 'is logged in' do
        subject

        expect(!session.id.nil?).to be_truthy
      end
    end

    context 'with invalid params' do
      let!(:user_params) do
        { user: { name: '' } }
      end

      it 'dose not create a new user' do
        expect { subject }.to_not change(User, :count)
      end
    end
  end
end
