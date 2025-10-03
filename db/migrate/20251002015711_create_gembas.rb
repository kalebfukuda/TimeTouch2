class CreateGembas < ActiveRecord::Migration[7.1]
  def change
    create_table :gembas do |t|
      t.string :name, null: false
      t.string :code
      t.references :company, null: false, foreign_key: true
      t.timestamps
    end
  end
end
