class CreateRegisters < ActiveRecord::Migration[7.1]
  def change
    create_table :registers do |t|
      t.datetime :date, null: false
      t.float :extra_hour
      t.integer :extra_cost
      t.references :gemba, null: false, foreign_key: true
      t.references :period, null: false, foreign_key: true
      t.references :profile, null: true, foreign_key: true
      t.timestamps
    end
  end
end
