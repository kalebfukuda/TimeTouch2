class AddLocaleToProfiles < ActiveRecord::Migration[7.1]
  def change
    add_column :profiles, :locale, :string
  end
end
