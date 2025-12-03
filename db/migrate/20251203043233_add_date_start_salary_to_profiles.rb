class AddDateStartSalaryToProfiles < ActiveRecord::Migration[7.1]
  def change
    add_column :profiles, :date_start_salary, :date
  end
end
