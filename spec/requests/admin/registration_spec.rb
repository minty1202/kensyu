require 'rails_helper'

RSpec.describe "User", type: :request do
  let(:user) { build(:user) }

  describe 'GET /admin/sign_up' do
    it "returns http success" do
      get new_admin_registration_path
      expect(response).to have_http_status :success
    end
  end

  describe 'POST /admin/registrations#create' do
    context '無効な値の場合' do
      it '無効な値だと登録されないこと' do
        expect {
          post admin_registration_path, params: { user: { name: '',
                                              email: 'user@invlid',
                                              password: 'foo',
                                              password_confirmation: 'bar' } }
        }.to_not change(User, :count)
      end
    end

    context '有効な値の場合' do
      it '登録されること' do
        expect {
          post admin_registration_path, params: :user
        }.to change(User, :count).by 1
      end

      it 'ログイン状態であること' do
        post admin_registration_path, params: user
        expect(!!session.id).to be_truthy
      end
    end
  end
end
