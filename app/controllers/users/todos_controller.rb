class Users::TodosController < UsersController
  def new
    @todo = Todo.new
  end

  def create
    @todo = Todo.new(title: todo_params[:title], text: todo_params[:text], user_id: current_user.id)
    if @todo.save
      flash[:success] = "登録が成功しました！"
      redirect_to users_mypage_path
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
    @todo = Todo.find(params[:id])
  end

  def update
    @todo = Todo.find(params[:id])

    if @todo.update(title: todo_params[:title], text: todo_params[:text], user_id: current_user.id)
      flash[:success] = "Todoを更新しました！"
      redirect_to users_mypage_path
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  private
    def todo_params
      params.require(:todo).permit(:title, :text)
    end
  end
