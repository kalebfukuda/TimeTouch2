class CreateRegisters < ActiveRecord::Migration[7.1]
  def change
    create_table :registers do |t|
      t.datetime :timestamp, null: false
      t.float :extra_hour, default: 0.0
      t.float :extra_cost, default: 0.0
      t.references :gemba, null: false, foreign_key: true
      t.references :period, null: false, foreign_key: true
      t.timestamps
    end
  end
end
