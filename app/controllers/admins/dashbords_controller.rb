class Admins::DashbordsController < AdminsController

  def show
    @users = User.includes(:todos)
  end
end
