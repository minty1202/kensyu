module Users
  class MypagesController < UsersController
    def show
      @todos = current_user.todos
    end
  end
end
