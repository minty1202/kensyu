namespace :change_status do
  desc '期限切れのTodoステータスをexpiredに変更'
  task change_expired: :environment do
    timeout_todos = Todo.where("limit_date < ?", Time.current).where(status: 'todo')
    timeout_todos.find_each do |timeout_todo|
      timeout_todo.status = 'expired'
      timeout_todo.save
    end
  end
end
