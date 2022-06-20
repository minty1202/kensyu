module Users
  class TodosController < UsersController
    before_action :find_todo_detail, only: [:edit, :update, :destroy]

    def new
      @todo = Todo.new(limit_date: Time.current)
    end

    def create
      @todo = current_user.todos.new(todo_params)
      if @todo.save
        @todo.save_tag(new_tag, checkbox_tag)
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
      if @todo.update(todo_params)
        @todo.save_tag(new_tag, checkbox_tag)
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
      params.require(:todo).permit(:title, :text, :limit_date, :status, images: [], tag_ids: []).merge(user_id: current_user.id)
    end

    def find_todo_detail
      @todo = current_user.todos.find(params[:id])
    end

    def new_tag
      # 送らててきた新しいタグの取得、空白がある場合一つの文字列にする
      params[:todo][:name].strip.split.join.split
    end

    def checkbox_tag
      return [] if params[:todo][:tag_ids].blank?

      params[:todo][:tag_ids].reject(&:empty?)
    end
  end
end
