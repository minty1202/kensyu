module Admins
  class DashbordsController < AdminsController
    def show
      @users = User.includes(:todos)
    end
  end
end
