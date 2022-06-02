class GeneralController < ApplicationController
  def index
    @todos = Todo.order(limit_date: "ASC").includes(:user).page(params[:page]).per(8)
  end
end
