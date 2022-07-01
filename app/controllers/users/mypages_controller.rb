module Users
  class MypagesController < UsersController
    include JudgeParams

    def show
      @set_todos = current_user.todos.order(limit_date: "ASC")
      @todos = @set_todos.page(params[:page]).per(8)
      @tags = current_user.tags.change_tag_order  # ビューでタグ一覧を表示するために全取得。
      judge_params
    end

    private

    def no_page
      redirect_to "/users/mypage"
      flash[:notice] = "データが見つかりませんでした。"
    end
  end
end
