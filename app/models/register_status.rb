class RegisterStatus < ApplicationRecord
  has_many :registers, dependent: :restrict_with_exception
  validates :name, presence: true
end
