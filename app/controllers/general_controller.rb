class GeneralController < ApplicationController
  def index
    @todos = Todo.includes(:user)
  end
end
