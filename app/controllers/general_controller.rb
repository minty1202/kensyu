class GeneralController < ApplicationController
  def index
    @todos = Todo.order(limit_date: "ASC").includes(:user).page(params[:page]).per(8)
    no_page if @todos.empty? && params[:page]
  end

  private

  def no_page
    redirect_to "/"
    flash[:notice] = "データが見つかりませんでした。"
  end
end
