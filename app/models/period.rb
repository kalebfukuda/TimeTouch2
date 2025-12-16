class Period < ApplicationRecord
  has_many :registers
  has_many :schedules
  validates :description, presence: true
end
