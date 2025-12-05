class Schedule < ApplicationRecord
  belongs_to :gemba
  belongs_to :profile
  belongs_to :period
  validates :date, presence: true

  # Virtual attribute for profile IDs
  attr_accessor :profile_ids
  attr_accessor :from_date
  attr_accessor :to_date
  attr_accessor :week_days
end
