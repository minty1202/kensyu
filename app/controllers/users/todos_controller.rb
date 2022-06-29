module Users
  class TodosController < UsersController
    before_action :find_todo_detail, only: [:edit, :update, :destroy]
    before_action :todo_params_for_update, only: :update
    before_action :delete_images, only: :update

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
        render 'new', status: :unprocessable_entity
      end
    end

    def edit
      @comment = Comment.new(todo_id: @todo.id, user_id: current_user.id)
    end

    def update
      puts '-----------2-----------------------'

      # 削除する画像がある場合（check boxにチェックがない場合はparamsにimage_idsはない）
      # return unless params[:todo][:image_ids]

      # delete_images
      if tag_todo_valid?(new_tag, @todo)
        puts '-----------3-----------------------'
        @todo.save
        @todo.save_tag(new_tag, checkbox_tag)
        flash[:success] = "Todoを更新しました！"
        redirect_to users_mypage_path
      else
        puts '-----------4-----------------------'
        @comment = Comment.new(todo_id: @todo.id, user_id: current_user.id)
        render 'edit', status: :unprocessable_entity
      end
      # # 削除する画像がある場合（check boxにチェックがない場合はparamsにimage_idsはない）
      # return unless params[:todo][:image_ids]

      # delete_images if @todo.valid?
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
      return unless params[:todo][:image_ids]
      puts '-----------1-----------------------'
      # puts params[:todo][:image_ids].class

      # params[:todo][:image_ids].each do |image_id| # params[:todo][:image_ids] は['121']

      # raise @todo.images.inspect
      # p @todo.images.each do |image|
      #   puts params[:todo][:image_ids]
      #   will_delete_image =  image if image.id.include(params[:todo][:image_ids])
      #   puts '------------delete-----------'
      #   puts  will_delete_image
      #   will_delete_image.purge
      # end



        # image = @todo.images.find(image_id)
        # p params[:todo][:image_ids] # ['121']
        # p image_id # 121

        # p image # 期待の形になる（削除のみの場合）<ActiveStorage::Attachment id: 114, name: "images", record_type: "Todo", record_id: 102, blob_id: 114, created_at: "2022-06-29 14:15:43.327990000 +0900">
        # p image.class # 削除だけの場合 ActiveStorage::Attachment(id: integer, name: string, record_type: string, record_id: integer, blob_id: integer, created_at: datetime)
        # image.purge
      # end
    end
  end
end
