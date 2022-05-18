class Users::TodosController < UsersController

  before_action :find_todo_detail, only:[:edit, :update, :destroy]

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

  def edit; end

  def update
    if @todo.update(title: todo_params[:title], text: todo_params[:text], user_id: current_user.id)
      flash[:success] = "Todoを更新しました！"
      redirect_to users_mypage_path
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @todo.destroy
    flash[:success] = "Todoを削除しました！"
    redirect_to users_mypage_path
  end

  private

    def todo_params
      params.require(:todo).permit(:title, :text)
    end

    def find_todo_detail
      @todo = current_user.todos.find(params[:id])
    end
  end
