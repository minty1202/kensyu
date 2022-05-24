class Users::CommentsController < ApplicationController

  def create
    @comment = current_user.comments.new(comment_params)
    if @comment.save
      # @todo = current_user.todos.find(params[:id])
      # redirect_to edit_users_todo(@todo)
      redirect_to edit_users_todo_path(@comment.todo)
      # render template: "todos/edit"
      # redirect_back fallback_location: root_path
    else
      # redirect_to edit_users_todo(@todo)
      redirect_to edit_users_todo_path(@comment.todo)
      # render template: "todos/edit"
      # redirect_back fallback_location: root_path
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:text, :todo_id).merge(user_id: current_user.id)
    end
end
