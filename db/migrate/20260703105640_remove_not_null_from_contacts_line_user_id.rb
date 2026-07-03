class RemoveNotNullFromContactsLineUserId < ActiveRecord::Migration[7.1]
  def change
    change_column_null :contacts, :line_user_id, true
  end
end
