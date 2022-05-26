module Users
  class CommentsController < ApplicationController
    def create
      @comment = current_user.comments.new(comment_params)
      @comment.save
      redirect_to edit_users_todo_path(@comment.todo)
    end

    private

    def comment_params
      params.require(:comment).permit(:text, :todo_id).merge(user_id: current_user.id)
    end
  end
end
