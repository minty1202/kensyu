module Users
  class TodosController < UsersController
    before_action :find_todo_detail, only: [:edit, :update, :destroy]

    def show
      @todo = Todo.find(params[:id])
      @comment = Comment.new(todo_id: @todo.id, user_id: current_user.id)
    end

    def new
      @todo = Todo.new
      @form = TodoTagForm.new(todo: @todo)
    end

    def create
      @todo = current_user.todos.new(todo_params)
      @form = TodoTagForm.new(todo_tag_form_params, todo: @todo)
      if @form.save
        flash[:success] = "登録が成功しました！"
        redirect_to users_mypage_path
      else
        @tags = params[:todo][:name]
        render 'new', status: :unprocessable_entity
      end
    end

    def edit
      @form = TodoTagForm.new(todo: @todo)
    end

    def update
      @form = TodoTagForm.new(todo_tag_form_params, todo: @todo)
      if @form.save
        flash[:success] = "Todoを更新しました！"
        redirect_to users_mypage_path
      else
        @tags = params[:todo][:name]
        @comment = Comment.new(todo_id: @todo.id, user_id: current_user.id)
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

    def todo_tag_form_params
      params.require(:todo).permit(:title, :text, :limit_date, :status, :name, images: [], tag_ids: [], image_ids: []).merge(user_id: current_user.id)
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

    def tag_todo_img_valid?(tag_names, todo)
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
      # 全体（既存数＋追加数） - 削除数 - 追加数  = 残った数
      left_images = @todo.images.count - params.dig(:todo, :image_ids).to_a.count
      if left_images <= 3
        true
      else
        @image_error = '3枚以上画像は登録できません'
        false
      end
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
        image = ActiveStorage::Attachment.find(image_id)
        image.purge
      end
    end

    def valid_each_tag(tag_names)
      # tag1つずつに対してバリデーションをかける、重複は省く
      @tags_errors = tag_names.map do |tag|
        tag = Tag.new(name: tag, user_id: current_user.id)
        tag.valid?
        tag.errors.full_messages
      end.flatten.uniq
    end
  end
end
