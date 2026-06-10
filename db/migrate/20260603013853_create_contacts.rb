class CreateContacts < ActiveRecord::Migration[7.1]
  def change
    create_table :contacts do |t|
      t.string :line_user_id,  null: false  # ex: U4af4980629...
      t.string :display_name
      t.boolean :opted_in, default: false
      t.references :user, null: true, foreign_key: true
    end
  end
end
