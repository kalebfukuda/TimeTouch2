class Contact < ApplicationRecord
  belongs_to :user

  validates :line_user_id, uniqueness: true, allow_nil: true
  validates :user_id,      uniqueness: true

  scope :opted_in, -> { where(opted_in: true) }

  # Atalho pra chegar no nome sem se preocupar com nils
  def user_name
    user&.name
  end

  def generate_invitation_token!
    update(
      invitation_token:      SecureRandom.urlsafe_base64(16),
      invitation_expires_at: 24.hours.from_now
    )
  end

  def invitation_valid?
    invitation_token.present? && invitation_expires_at&.future?
  end

  def invitation_link
    "https://line.me/R/oaMessage/@#{ENV['LINE_BOT_ID']}/?#{invitation_token}"
  end
end
