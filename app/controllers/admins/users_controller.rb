class Admins::UsersController < AdminsController

  def index; end

  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to admins_dashbord_path
  end
end
