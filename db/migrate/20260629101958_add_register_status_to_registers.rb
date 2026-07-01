class AddRegisterStatusToRegisters < ActiveRecord::Migration[7.1]
  def change
    add_reference :registers, :register_status, foreign_key: true
  end
end
