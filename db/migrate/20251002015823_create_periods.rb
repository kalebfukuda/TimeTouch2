class CreatePeriods < ActiveRecord::Migration[7.1]
  def change
    create_table :periods do |t|
      t.string :description, null: false
      t.timestamps
    end
  end
end
