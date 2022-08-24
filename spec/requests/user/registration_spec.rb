require 'rails_helper'

RSpec.describe "User", type: :request do
  describe 'GET /users/sign_up' do
    it "returns http success" do
      get new_user_registration_path
      expect(response).to have_http_status :success
    end
  end

  describe 'POST /users/registrations#create' do
    let(:user_params) do
      { user: { name: 'test',
                email: 'test@example.com',
                password: '123456',
                password_confirmation: '123456' } }
    end
    context '無効な値の場合' do
      it '無効な値だと登録されないこと' do
        expect do
          post user_registration_path, params: { user_params: { name: '',
                                                                email: 'user@invlid',
                                                                password: 'foo',
                                                                password_confirmation: 'bar' } }
        end.to_not change(User, :count)
      end
    end
    context '有効な値の場合' do
      subject { post user_registration_path, params: user_params }
      it '登録されること' do
        expect { subject }.to change(User, :count).by 1
      end

      it 'ログイン状態であること' do
        subject
        expect(!session.id.nil?).to be_truthy
      end
    end
  end
end
