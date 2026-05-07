class Profile < ApplicationRecord
  scope :with_register_stats, ->(start_date, end_date) {
    registers_agg = Register
      .where(date: start_date..end_date)
      .select("
        profile_id,
        COUNT(*) AS total_days,
        COALESCE(SUM(extra_hour), 0) AS total_extra_hours,
        COALESCE(SUM(extra_cost), 0) AS total_extra_cost,
        COALESCE(SUM(
          salary
          + COALESCE(extra_hour, 0) * (salary / 8.0 * 1.25)
          + COALESCE(extra_cost, 0)
        ), 0) AS total_earned
      ")
      .group("profile_id")

    joins("LEFT JOIN (#{registers_agg.to_sql}) reg ON reg.profile_id = profiles.id")
      .select("
        profiles.*,
        COALESCE(reg.total_days, 0) AS total_days,
        COALESCE(reg.total_extra_hours, 0) AS total_extra_hours,
        COALESCE(reg.total_extra_cost, 0) AS total_extra_cost,
        COALESCE(reg.total_earned, 0) AS total_earned
      ")
      .order(active: :desc, name: :asc)
  }
  before_update :handle_salary_change, if: :will_save_change_to_salary?

  belongs_to :role
  belongs_to :company
  belongs_to :user
  has_many :schedules, dependent: :destroy
  has_many :registers, dependent: :destroy
  validates :name, presence: true
  validates :salary, numericality: { greater_than_or_equal_to: 0 }
  validates :locale, inclusion: {
    in: I18n.available_locales.map(&:to_s),
    allow_nil: true
  }
  private

  def handle_salary_change
    self.previous_salary = salary_was
    self.date_start_salary = date_start_salary
  end
end
