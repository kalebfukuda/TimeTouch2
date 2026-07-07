class MakeRegisterStatusNotNull < ActiveRecord::Migration[7.1]
  def change
      change_column_null :registers, :register_status_id, false
  end
end
