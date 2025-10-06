class CreateSchedules < ActiveRecord::Migration[7.1]
  def change
    create_table :schedules do |t|
      t.date :date, null: false
      t.references :gemba, null: false, foreign_key: true
      t.references :profile, null: false, foreign_key: true
      t.timestamps
    end
  end
end
