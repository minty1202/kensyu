MAX_ATTEMPTS = 3
num_attempts = 0

namespace :todo_notifier do
  desc '1日後に終了期限の未完了Todoを取得して通知'
  task get_todo_status: :environment do
    num_attempts += 1
    Todo.notice_expired_todo
  rescue StandardError => e
    if num_attempts < MAX_ATTEMPTS
      sleep 60
      retry
    else
      puts e
    end
    message = "1日後に終了期限のTodo取得が失敗しました!(#{num_attempts}回目目)"
    Todo.send_error_message(message)
  end
end
