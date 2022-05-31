module Users
  class TagsController < UsersController
    def show
      @tag = Tag.find(params[:id])  # クリックしたタグを取得
      @todos = @tag.todos.all.page(params[:page]).per(8)  # クリックしたタグに紐付けられた投稿を全て表示
    end
  end
end
