class GeneralController < ApplicationController
  include JudgeParams

  def index
    @set_todos = Todo.order(limit_date: "ASC").includes(:user)
    @todos = @set_todos.page(params[:page]).per(8)
    judge_params
  end

  private

  def no_page
    redirect_to "/"
    flash[:notice] = "データが見つかりませんでした。"
  end
end
