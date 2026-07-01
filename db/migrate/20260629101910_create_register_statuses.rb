class CreateRegisterStatuses < ActiveRecord::Migration[7.1]
  def change
    create_table :register_statuses do |t|
      t.string :name
      t.string :color

      t.timestamps
    end
  end
end
