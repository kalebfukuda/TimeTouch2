class AddInvitationTokenToContacts < ActiveRecord::Migration[7.1]
  def change
    add_column :contacts, :invitation_token, :string
    add_column :contacts, :invitation_expires_at, :datetime
  end
end
