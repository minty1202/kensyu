module Users
  class CommentsController < ApplicationController
    def create
      @comment = current_user.comments.new(comment_params)
      if @comment.save
        redirect_to users_todo_path(@comment.todo)
        flash[:success] = "コメントを投稿しました！"
      else
        @todo = Todo.find(comment_params[:todo_id])
        @tags = Tag.new(user_id: current_user.id)
        render 'users/todos/show', status: :unprocessable_entity
      end
    end

    private

    def comment_params
      params.require(:comment).permit(:text, :todo_id).merge(user_id: current_user.id)
    end
  end
end
