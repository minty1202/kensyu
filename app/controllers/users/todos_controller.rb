module Users
  class TodosController < UsersController
    before_action :find_todo_detail, only: [:edit, :update, :destroy]

    def new
      @todo = Todo.new
    end

    def create
      @todo = current_user.todos.new(todo_params)
      tags = params[:todo][:name].split(',') # 送らててきたタグの取得, tagsは配列
      if @todo.save
        @todo.save_tag(tags)
        flash[:success] = "登録が成功しました！"
        redirect_to users_mypage_path
      else
        render 'new', status: :unprocessable_entity
      end
    end

    def edit
      @comment = Comment.new(todo_id: @todo.id, user_id: current_user.id)
    end

    def update
      tags = params[:todo][:name].split(',')
      if @todo.update(todo_params)
        # 今のtodoに紐付いているtagを消す
        @old_tags = TodoTag.where(todo_id: @todo.id)
        @old_tags.each do |old_tag|
          old_tag.delete
        end
        @todo.save_tag(tags)
        flash[:success] = "Todoを更新しました！"
        redirect_to users_mypage_path
      else
        @comment = Comment.new(todo_id: @todo.id, user_id: current_user.id)
        render 'edit', status: :unprocessable_entity
      end

      # 削除する画像がある場合（check boxにチェックがない場合はparamsにimage_idsはない）
      return unless params[:todo][:image_ids]

      params[:todo][:image_ids].each do |image_id|
        image = @todo.images.find(image_id)
        image.purge
      end
    end

    def destroy
      @todo.destroy
      flash[:success] = "Todoを削除しました！"
      redirect_to users_mypage_path
    end

    private

    def todo_params
      params.require(:todo).permit(:title, :text, images: []).merge(user_id: current_user.id)
    end

    def find_todo_detail
      @todo = current_user.todos.find(params[:id])
    end
  end
end
