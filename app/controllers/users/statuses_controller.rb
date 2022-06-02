module Users
  class StatusesController < UsersController
    def find_status
      @todos = current_user.todos.where(status: params[:status]).order(limit_date: "ASC").page(params[:page]).per(8)
    end
  end
end
