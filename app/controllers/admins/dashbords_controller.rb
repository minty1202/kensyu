class Admins::DashbordsController < AdminsController

  def show
    @users = User.includes(:todos)
    render "admins/users/index"
  end
end
