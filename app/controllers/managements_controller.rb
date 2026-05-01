class ManagementsController < ApplicationController
  def index
    @month = (params[:month] || Date.today.month).to_i
    @year  = (params[:year]  || Date.today.year).to_i

    start_date = Date.new(@year, @month, 1)
    end_date   = start_date.end_of_month

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
    @month = (params[:month] || Date.today.month).to_i
    @year  = (params[:year]  || Date.today.year).to_i

    start_date = Date.new(@year, @month, 1)
    end_date   = start_date.end_of_month
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
