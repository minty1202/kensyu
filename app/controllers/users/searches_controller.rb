module Users
  class SearchesController < UsersController
    def search
      @range = params[:range]
      @search = params[:search]

      if @range == 'User'
        @users = User.lookfor(params[:search], params[:word], :todos, 'name')
      else
        @todos = Todo.lookfor(params[:search], params[:word], :user, 'title')
      end
    end
  end
end
