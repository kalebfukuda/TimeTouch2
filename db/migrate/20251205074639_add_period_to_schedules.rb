class AddPeriodToSchedules < ActiveRecord::Migration[7.1]
  def change
    add_reference :schedules, :period, null: false, foreign_key: true
  end
end
