module Users
  class TodosController < UsersController
    before_action :find_todo_detail, only: [:edit, :update, :destroy]
    before_action :todo_params_for_update, only: :update

    def new
      @todo = Todo.new(limit_date: Time.current)
      # @tags = Tag.all || Tag.new(user_id: current_user.id)
    end

    def create
      # @tags = Tag.new(name: params[:todo][:name], user_id: current_user.id)
      @todo = current_user.todos.new(todo_params)
      if tag_todo_valid?(new_tag, @todo)
        @todo.save
        @todo.save_tag(new_tag, checkbox_tag)
        flash[:success] = "登録が成功しました！"
        redirect_to users_mypage_path
      else
        render 'new', status: :unprocessable_entity
      end
    end

    def edit
      @comment = Comment.new(todo_id: @todo.id, user_id: current_user.id)
      # @tags = Tag.new(user_id: current_user.id)
    end

    def update
      # @tags = Tag.new(name: params[:todo][:name], user_id: current_user.id)
      if tag_todo_valid?(new_tag, @todo)
        @todo.save
        @todo.save_tag(new_tag, checkbox_tag)
        flash[:success] = "Todoを更新しました！"
        redirect_to users_mypage_path
      else
        @comment = Comment.new(todo_id: @todo.id, user_id: current_user.id)
        render 'edit', status: :unprocessable_entity
      end

      # 削除する画像がある場合（check boxにチェックがない場合はparamsにimage_idsはない）
      return unless params[:todo][:image_ids]

      delete_images
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
      # 送らててきた新しいタグの取得、空白を省き、カンマで区切り配列にする
      params[:todo][:name].gsub(/\s+/, "").split(',')
    end

    def checkbox_tag
      return [] if params[:todo][:tag_ids].blank?

      params[:todo][:tag_ids].reject(&:empty?)
    end

    def tag_todo_valid?(tag_names, todo)
      @tags_errors = tag_names.map do |tag|
        tag = Tag.new(name: tag, user_id: current_user.id)
        tag.valid?
        tag.errors.full_messages
      end.flatten
      # tag.valid?
      todo.valid?
      @tags_errors.empty? && todo.errors.empty?
    end

    def todo_params_for_update
      @todo = Todo.find(params[:id])
      @todo.title = todo_params[:title]
      @todo.text = todo_params[:text]
      @todo.limit_date = todo_params[:limit_date]
      @todo.status = todo_params[:status]
      @todo.images = todo_params[:images]
    end

    def delete_images
      params[:todo][:image_ids].each do |image_id|
        image = @todo.images.find(image_id)
        image.purge
      end
    end
  end
end
