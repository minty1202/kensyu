class Admins::DashbordsController < AdminsController

  def show
    @users = User.includes(:todos)
  end

  def destroy
    user = User.find(params[:format])
    user.destroy
    redirect_to admins_dashbord_path
  end
end
