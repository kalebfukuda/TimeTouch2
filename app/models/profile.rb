class Profile < ApplicationRecord

  belongs_to :role
  belongs_to :company
  belongs_to :user
  validates :name, presence: true
  validates :salary, numericality: { greater_than_or_equal_to: 0 }
end
