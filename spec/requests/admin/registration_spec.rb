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

    context '有効な値の場合' do
      let!(:admin_params) do
        { admin: { email: 'admin@example.com',
                   password: '123456' } }
      end

      it '管理者を新しく作れること' do
        expect { subject }.to change(Admin, :count).by 1
      end

      it 'ログイン状態であること' do
        subject

        expect(session.id).not_to be_nil
      end
    end

    context '無効な値の場合' do
      let!(:admin_params) do
        { admin: { email: '',
                   password: '' } }
      end

      it '管理者を新しく作れないこと' do
        expect { subject }.to_not change(Admin, :count)
      end
    end
  end
end
