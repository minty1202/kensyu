module Users
  class TagsController < UsersController
    before_action :set_tag, only: [:edit, :update, :destroy]

    def show
      @tag = Tag.find(params[:id]) # クリックしたタグを取得
      @todos = @tag.todos.all.page(params[:page]).per(8)  # クリックしたタグに紐付けられた投稿を全て表示
    end

    def edit
      @form = TagForm.new(tag: @tag)
    end

    def update
      @form = TagForm.new(tag_params, tag: @tag)

      if @form.save
        flash[:success] = "タグを更新しました！"
        redirect_to users_mypage_path
      else
        render 'edit', status: :unprocessable_entity
      end
    end

    def destroy
      @tag.destroy
      flash[:success] = "タグを削除しました！"
      redirect_to users_mypage_path
    end

    private

    def tag_params
      params.require(:tag).permit(:name).merge(user_id: current_user.id)
    end

    def set_tag
      @tag = current_user.tags.find(params[:id])
    end
  end
end
