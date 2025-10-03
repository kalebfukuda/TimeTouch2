class Schedule < ApplicationRecord
  belongs_to :gemba
  belongs_to :profile
  validates :date, presence: true
end
