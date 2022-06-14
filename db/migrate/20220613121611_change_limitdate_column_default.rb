class ChangeLimitdateColumnDefault < ActiveRecord::Migration[7.0]
  def change
    change_column_default :todos, :limit_date, nil
  end
end
