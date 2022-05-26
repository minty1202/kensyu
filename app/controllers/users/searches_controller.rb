module Users
  class SearchesController < UsersController
    def search
      @range = params[:range]

      if @range == 'User'
        @users = User.includes(:todos).lookfor(params[:search], params[:word])
      else
        @todos = Todo.includes(:user).lookfor(params[:search], params[:word])
      end
    end
  end
end
