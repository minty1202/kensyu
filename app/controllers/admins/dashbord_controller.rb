class Admins::DashbordController < AdminsController

  def show
    @users = User.includes(:todos)
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to admins_dashbord_path(current_admin)
  end
end
