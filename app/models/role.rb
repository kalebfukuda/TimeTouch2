class Role < ApplicationRecord
  has_many :profiles
  validates :description, presence: true
end
