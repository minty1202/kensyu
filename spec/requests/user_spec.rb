require 'rails_helper'

RSpec.describe "User", type: :request do
  before do
    @user = FactoryBot.build(:user)
  end

  describe 'GET /users/sign_up' do
    it "returns http success" do
      get new_user_registration_path
      expect(response).to have_http_status :success
    end
  end

  describe 'POST /users/registrations#create' do
    it '無効な値だと登録されないこと' do
      expect {
        post user_registration_path, params: { user: { name: '',
                                            email: 'user@invlid',
                                            password: 'foo',
                                            password_confirmation: 'bar' } }
      }.to_not change(User, :count)
    end
  end

  describe 'POST /users/registrations#create' do
    context '有効な値の場合' do
      let(:user_params) { { user: { name: 'user',
                                    email: 'user@example.com',
                                    password: 'password',
                                    password_confirmation: 'password' } } }

      it '登録されること' do
        expect {
          post user_registration_path, params: user_params
        }.to change(User, :count).by 1
      end

      it 'root_pathにリダイレクトされること' do
        post user_registration_path, params: user_params
        user = User.last
        expect(response).to redirect_to root_path
      end

      it 'ログイン状態であること' do
        post user_registration_path, params: user_params
        expect(response).to have_http_status(302)
      end
    end
  end
end
