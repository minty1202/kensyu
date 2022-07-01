module Users
  class MypagesController < UsersController
    def show
      @todos = current_user.todos.order(limit_date: "ASC").page(params[:page]).per(8)
      @tags = current_user.tags.change_tag_order.to_a  # ビューでタグ一覧を表示するために全取得。
    end
  end
end
