module Users
  class TagsController < UsersController
    def show
      @tag = Tag.find(params[:id])  #クリックしたタグを取得
      @todos = @tag.todos.all  #クリックしたタグに紐付けられた投稿を全て表示
      puts '------------------------'
      puts '---------@todos-----------'
      puts @todos.count #0になる
    end
  end
end
