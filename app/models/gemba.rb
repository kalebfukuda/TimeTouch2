class Gemba < ApplicationRecord
  belongs_to :company
  has_many :registers
  validates :name, presence: true
end
