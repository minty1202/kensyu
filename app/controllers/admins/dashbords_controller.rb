class Admins::DashbordsController < AdminsController

  def show
    @users = User.includes(:todos)
  end

  def destroy
    puts '-----------------------------------'
    puts '-----------------------------------'
    pp params
    @user = User.find(params[:id])
    puts '-----------------------------------'
    puts '-----------------------------------'
    pp @user
    puts '-----------------------------------'
    puts '-----------------------------------'
    user = User.find(params[:id])
    user.destroy
    redirect_to admins_dashbord_path
  end
end
