module Users
  class TodosController < UsersController
    before_action :find_todo_detail, only: [:edit, :update, :destroy]
    before_action :todo_params_for_update, only: :update

    def new
      @todo = Todo.new(limit_date: Time.current)
    end

    def create
      @todo = current_user.todos.new(todo_params)
      if tag_todo_valid?(new_tag, @todo)
        @todo.save
        @todo.save_tag(new_tag, checkbox_tag)
        flash[:success] = "登録が成功しました！"
        redirect_to users_mypage_path
      else
        @tags = params[:todo][:name]
        render 'new', status: :unprocessable_entity
      end
    end

    def edit
      @comment = Comment.new(todo_id: @todo.id, user_id: current_user.id)
    end

    def update
      if tag_todo_valid?(new_tag, @todo)
        @todo.save(context: :to_delete_images)
        @todo.save_tag(new_tag, checkbox_tag)
        flash[:success] = "Todoを更新しました！"
        redirect_to users_mypage_path
        delete_images if params[:todo][:image_ids]
      else
        @tags = params[:todo][:name]
        @comment = Comment.new(todo_id: @todo.id, user_id: current_user.id)
        flash[:notice] = "更新に失敗しました。"
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
      # tag1つずつに対してバリデーションをかける、重複は省く
      @tags_errors = tag_names.map do |tag|
        tag = Tag.new(name: tag, user_id: current_user.id)
        tag.valid?
        tag.errors.full_messages
      end.flatten.uniq

      return unless todo.valid?(:to_delete_images) && image_valid?

      @tags_errors.empty? && todo.errors.empty?
    end

    def image_valid?
      # 既存の数 - 削除数  = 残った数
      left_images_ids = params[:all_image_ids].to_a.count - params[:todo][:image_ids].to_a.count
      # 残った数 + 追加数 = 合計数
      if params[:todo][:images]
        new_and_old_images_ids = left_images_ids + params[:todo][:images].to_a.count
      else
        new_and_old_images_ids = left_images_ids + 0
      end
      new_and_old_images_ids <= 3
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
      return unless params[:todo][:image_ids]

      params[:todo][:image_ids].each do |image_id|
        image = ActiveStorage::Attachment.find(image_id)
        image.purge
      end
    end
  end
end
