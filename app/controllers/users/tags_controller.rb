module Users
  class TagsController < UsersController
    def show
      @tag = current_user.tags.find(params[:id]) # クリックしたタグを取得
      @todos = @tag.todos.all.page(params[:page]).per(8)  # クリックしたタグに紐付けられた投稿を全て表示
    end

    def edit
      @tag = current_user.tags.find(params[:id])
    end

    def update
      @tag = current_user.tags.find(params[:id])
      if @tag.update(tag_params)
        flash[:success] = "タグを更新しました！"
        redirect_to users_mypage_path
      else
        render 'edit', status: :unprocessable_entity
      end
    end

    def destroy
      @tag = current_user.tags.find(params[:id])
      @tag.destroy
      flash[:success] = "タグを削除しました！"
      redirect_to users_mypage_path
    end

    private

    def tag_params
      params.require(:tag).permit(:name).merge(user_id: current_user.id)
    end
  end
end
