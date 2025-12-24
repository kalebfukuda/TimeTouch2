class AddNoteToRegisters < ActiveRecord::Migration[7.1]
  def change
    add_column :registers, :note, :string
  end
end
