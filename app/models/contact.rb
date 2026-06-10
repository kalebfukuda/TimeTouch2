class Contact < ApplicationRecord
  belongs_to :user

  validates :line_user_id, presence: true, uniqueness: true
  validates :user_id,      uniqueness: true

  scope :opted_in, -> { where(opted_in: true) }

  # Atalho pra chegar no nome sem se preocupar com nils
  def user_name
    user&.name
  end
end
