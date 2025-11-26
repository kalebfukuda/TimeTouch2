class Register < ApplicationRecord
  before_validation :set_default_values

  belongs_to :gemba
  belongs_to :period
  belongs_to :profile
  validates :date, presence: true
  validates :extra_hour, numericality: { greater_than_or_equal_to: 0 }
  validates :extra_cost, numericality: { greater_than_or_equal_to: 0 }

  private

   def set_default_values
    self.extra_hour = 0.0 if extra_hour.blank?
    self.extra_cost = 0 if extra_cost.blank?
  end
end
