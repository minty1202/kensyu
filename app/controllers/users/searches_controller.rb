module Users
  class SearchesController < UsersController
    def search
      @range = params[:range]
      @search = params[:search]

      if @range == 'User'
        @users = User.lookfor(params[:search], params[:word])
      else
        @todos = Todo.lookfor(params[:search], params[:word])
      end
    end
  end
end
