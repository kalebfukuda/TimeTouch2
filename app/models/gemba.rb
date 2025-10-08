class Gemba < ApplicationRecord
  belongs_to :company
  has_many :registers
  has_many :schedules
  validates :name, presence: true
end
