class AddPreviousSalaryToProfiles < ActiveRecord::Migration[7.1]
  def change
    add_column :profiles, :previous_salary, :float
  end
end
