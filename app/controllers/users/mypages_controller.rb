module Users
  class MypagesController < UsersController
    def show
      @todos = current_user.todos.order(limit_date: "ASC").page(params[:page]).per(8)
      @tags = current_user.tags.change_tag_order.to_a  # ビューでタグ一覧を表示するために全取得。
      @tag_have_todos = @tags.select { |tag| tag.todos.present? }
      no_page if @todos.empty? && params[:page]
    end

    private

    def no_page
      redirect_to "/users/mypage"
      flash[:notice] = "データが見つかりませんでした。"
    end
  end
end
