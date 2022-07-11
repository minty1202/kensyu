MAX_ATTEMPTS = 3
num_attempts = 0

namespace :change_status do
  desc '期限切れのTodoステータスをexpiredに変更'
  task change_expired: :environment do
    num_attempts += 1
    Todo.change_status
  rescue StandardError => e
    if num_attempts <= MAX_ATTEMPTS
      sleep 60
      message = p "期限切れのTodoステータス変更が失敗しました!(#{num_attempts}回目目)"
      Todo.send_error_message(message) if num_attempts == MAX_ATTEMPTS
      retry
    else
      puts e
    end
  ensure
    puts 'finish!!!!!!!!!!!!!!!!!!!!!'
  end
end
