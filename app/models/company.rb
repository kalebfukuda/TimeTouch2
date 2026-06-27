class Company < ApplicationRecord
  has_many :profiles
  has_many :gembas
  has_many :registers, through: :gembas
  has_many :schedules, through: :gembas
  validates :name, presence: true
end
