class Profile < ApplicationRecord
  before_update :handle_salary_change, if: :will_save_change_to_salary?

  belongs_to :role
  belongs_to :company
  belongs_to :user
  has_many :schedules, dependent: :destroy
  validates :name, presence: true
  validates :salary, numericality: { greater_than_or_equal_to: 0 }

  private

  def handle_salary_change
    self.previous_salary = salary_was
    self.date_start_salary = date_start_salary
  end
end
