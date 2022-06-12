namespace :todo_notifier do
  desc '1日後に終了期限の未完了Todoを取得して通知'
  task get_todo_status: :environment do
    Todo.notice_expired_todo
  end
end
