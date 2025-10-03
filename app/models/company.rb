class Company < ApplicationRecord
  has_many :profiles
  has_many :gembas
  validates :name, presence: true
end
