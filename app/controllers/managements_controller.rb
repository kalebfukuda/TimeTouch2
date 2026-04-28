class ManagementsController < ApplicationController
  def index
    start_date = Date.current.beginning_of_month
    end_date = Date.current.end_of_month
    company = current_user.profiles.first.company
    @name = company.name
    @profiles = company.profiles
      .with_register_stats(start_date, end_date)

    @total_earned = @profiles.sum(&:total_earned)
    @total_days   = @profiles.sum(&:total_days)
    @total_active_employees = @profiles.count { |p| p.active }


    @registers = Register.joins(:profile)
      .where(profiles: { company_id: company.id }, date: start_date..end_date)
      .joins(:gemba)
      .select('registers.*, profiles.name as profile_name')
      .order(date: :desc)
  end

  def stats
    start_date = Date.current.beginning_of_month
    end_date   = Date.current.end_of_month
    company    = current_user.profiles.first.company

    profiles = company.profiles.with_register_stats(start_date, end_date)
    profiles = profiles.where(id: params[:profile_id]) if params[:profile_id].present?

    @total_earned           = profiles.sum(&:total_earned)
    @total_days             = profiles.sum(&:total_days)
    @total_employees        = profiles.count
    @total_active_employees = profiles.count(&:active)

    render partial: "stats"
  end
end
