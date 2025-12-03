class AddSalaryToRegisters < ActiveRecord::Migration[7.1]
  def change
    add_column :registers, :salary, :decimal
  end
end
