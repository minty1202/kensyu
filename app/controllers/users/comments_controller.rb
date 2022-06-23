module Users
  class CommentsController < ApplicationController
    def create
      @comment = Comment.new(comment_params)
      if @comment.save
        redirect_to edit_users_todo_path(@comment.todo)
      else
        @todo = Todo.find(comment_params[:todo_id])
        render '/users/todos/edit', status: :unprocessable_entity
      end
    end

    private

    def comment_params
      params.require(:comment).permit(:text, :todo_id).merge(user_id: current_user.id)
    end
  end
end
