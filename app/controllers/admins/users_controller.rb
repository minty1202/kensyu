# frozen_string_literal: true

module Admins
  class UsersController < AdminsController
    def index; end

    def destroy
      user = User.find(params[:id])
      user.destroy
      redirect_to admins_dashbord_path
    end
  end
end
