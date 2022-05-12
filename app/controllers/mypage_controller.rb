class MypageController < ApplicationController
  def show
    @user = User.find(params[:id])
    @todos = Todo.where(user_id: @user.id )
  end
end
