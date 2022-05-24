class Admins::DashbordController < ApplicationController
  before_action :authenticate_admin!

  def show
    @users = User.all
  end

  def destroy
    pp params
    pp params[:id]
    @user = User.find(params[:id])
    puts '-----------------------------------'
    puts '-----------------------------------'
    pp @user
    puts '-----------------------------------'
    puts '-----------------------------------'
    @user.destroy

    # flash[:success] = "ユーザーを削除しました！"
    # redirect_to root_path
    redirect_to admins_dashbord_path(current_admin)
    # render 'show'
  end

  # private
  #   def find_todo_detail
  #     @todo = current_user.todos.find(params[:id])
  #   end
end
