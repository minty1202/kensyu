class AddLimitDateAndStatusToTodos < ActiveRecord::Migration[7.0]
  def change
    add_column :todos, :limit_date, :date, null: false, default: Time.current.since(3.days)
    add_column :todos, :status, :string, null: false, default: 'todo'
  end
end
