class AddActiveToProfiles < ActiveRecord::Migration[7.1]
  def change
    add_column :profiles, :active, :boolean
  end
end
