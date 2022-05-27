module Users
  class MypagesController < UsersController
    def show
      @todos = current_user.todos.page(params[:page]).per(8)
    end
  end
end
