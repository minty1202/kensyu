class GeneralController < ApplicationController
  def index
    @todos = Todo.includes(:user).page(params[:page]).per(8)
  end
end
