class Users::MypagesController < UsersController
  def show
    @todo = current_user.todos
  end
end
