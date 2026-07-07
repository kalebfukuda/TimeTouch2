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
    @schedules = Schedule.where(profile: profile, date: range).includes(:gemba, :period)

    @registers_by_date = @registers.group_by { |r| r.date.to_date }
    @schedules_by_date = @schedules.group_by { |s| s.date.to_date }
    @last_extra_cost = Register.where(profile: profile, register_status_id: 1)
                            .order(date: :desc)
                            .limit(1)
                            .pick(:extra_cost) || 0
  end
end
