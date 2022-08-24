require 'rails_helper'

RSpec.describe "Admin", type: :request do
  # let(:admin) { build(:admin) }

  describe 'GET /admin/sign_up' do
    it "returns http success" do
      get new_admin_registration_path
      expect(response).to have_http_status :success
    end
  end

  describe 'POST /admin/registrations#create' do
    context '無効な値の場合' do
      it '無効な値だと登録されないこと' do
        expect do
          post admin_registration_path, params: { admin: { email: 'user@invlid',
                                                           password: 'foo' } }
        end.to_not change(Admin, :count)
      end
    end

    context '有効な値の場合' do
      let(:admin_params) do
        { admin: { email: 'admin@example.com',
                   password: '123456' } }
      end
      it '登録されること' do
        expect do
          post admin_registration_path, params: admin_params
        end.to change(Admin, :count).by 1
      end

      it 'ログイン状態であること' do
        post admin_registration_path, params: admin_params
        expect(!session.id.nil?).to be_truthy
      end
    end
  end
end
