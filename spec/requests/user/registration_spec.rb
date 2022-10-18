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

    context '有効な値の場合' do
      let!(:user_params) do
        { user: { name: 'test',
                  email: 'test@example.com',
                  password: '123456',
                  password_confirmation: '123456' } }
      end

      it 'ユーザーを新しく作れること ' do
        expect { subject }.to change(User, :count).by(1)
      end

      it 'ログイン状態であること' do
        subject

        expect(session.id).not_to be_nil
      end
    end

    context '無効な値の場合' do
      let!(:user_params) do
        { user: { name: '' } }
      end

      it 'ユーザーを新しく作れないこと' do
        expect { subject }.to_not change(User, :count)
      end
    end
  end
end
