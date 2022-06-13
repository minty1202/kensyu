namespace :change_status do
  desc '期限切れのTodoステータスをexpiredに変更'
  task change_expired: :environment do
    Todo.change_status
  end
end
