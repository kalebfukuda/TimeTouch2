class CreateRegisterStatus < ActiveRecord::Migration[7.1]
  def change
    create_table :register_status do |t|
      t.string :name, null: false
      t.string :color

      t.timestamps
    end
  end
end
