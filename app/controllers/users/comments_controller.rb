module Users
  class CommentsController < ApplicationController
    def create
      @comment = current_user.comments.new(comment_params)
      if @comment.save
        redirect_to edit_users_todo_path(@comment.todo)
        flash[:success] = "コメントの登録が成功しました！"
      else
        @todo = Todo.find(comment_params[:todo_id])
        render 'users/todos/edit', status: :unprocessable_entity
      end
    end

    private

    def comment_params
      params.require(:comment).permit(:text, :todo_id).merge(user_id: current_user.id)
    end
  end
end
