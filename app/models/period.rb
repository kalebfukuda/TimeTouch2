class Period < ApplicationRecord
  has_many :registers
  validates :description, presence: true
end
