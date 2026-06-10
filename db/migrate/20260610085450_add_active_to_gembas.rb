class AddActiveToGembas < ActiveRecord::Migration[7.1]
  def change
    add_column :gembas, :active, :boolean, default: true, null: false
  end
end
