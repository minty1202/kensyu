module Users
  class StatusesController < UsersController
    def find_todo
      @todos = current_user.todos.where(status: "todo").order(limit_date: "ASC").page(params[:page]).per(8)
    end

    def find_done
      @todos = current_user.todos.where(status: "done").order(limit_date: "ASC").page(params[:page]).per(8)
    end

    def find_expired
      @todos = current_user.todos.where(status: "expired").order(limit_date: "ASC").page(params[:page]).per(8)
    end
  end
end
