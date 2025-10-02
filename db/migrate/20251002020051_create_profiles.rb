class CreateProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :profiles do |t|
      t.string :name, null: false
      t.float :salary, default: 0.0
      t.references :role, null: false, foreign_key: true
      t.timestamps
    end
  end
end
