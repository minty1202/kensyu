class GeneralController < ApplicationController
  def index
    @todos = Todo.all
  end
end
