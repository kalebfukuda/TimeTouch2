class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]
  before_action :authenticate_user!, only: [:main]

  def home
  end

  def main
    profile = current_user.profiles.first
    current_month = (params[:start_date]&.to_date || Date.current)
    range = current_month.beginning_of_month.beginning_of_week..
            current_month.end_of_month.end_of_week

    @register = Register.new
    @registers = Register.where(profile: profile, date: range)
    @schedule = Schedule.find_by(date: Date.current, profile: current_user.profiles.first)
    @schedules = Schedule.where(profile: profile, date: range)

    @registers_by_date = @registers.group_by(&:date)
    @schedules_by_date = @schedules.group_by(&:date)
  end
end
