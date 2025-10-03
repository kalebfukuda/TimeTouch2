class Register < ApplicationRecord
  belongs_to :gemba
  belongs_to :period
  belongs_to :profile
  validates :date, presence: true
  validates :extra_hour, numericality: { greater_than_or_equal_to: 0 }
  validates :extra_cost, numericality: { greater_than_or_equal_to: 0 }
end
