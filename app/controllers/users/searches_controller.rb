module Users
  class SearchesController < UsersController
    def search
      @range = params[:range]

      if @range == 'User'
        @users = User.lookfor(params[:search], params[:word])
      else
        @todos = Todo.lookfor(params[:search], params[:word])
      end
    end
  end
end
