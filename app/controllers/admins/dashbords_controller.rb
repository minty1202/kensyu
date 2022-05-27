module Admins
  class DashbordsController < AdminsController
    def show
      @users = User.includes(:todos).page(params[:page]).per(8)
    end
  end
end
