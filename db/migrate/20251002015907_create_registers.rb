class CreateRegisters < ActiveRecord::Migration[7.1]
  def change
    create_table :registers do |t|

      t.timestamps
    end
  end
end
