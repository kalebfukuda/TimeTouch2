class ManagementsController < ApplicationController
  def index
    @month = (params[:month] || Date.today.month).to_i
    @year  = (params[:year]  || Date.today.year).to_i

    start_date = Date.new(@year, @month, 1)
    end_date   = start_date.end_of_month

    company = current_user.profiles.first.company

    @profiles = company.profiles
      .with_register_stats(start_date, end_date)

    @selected_profile = Profile.find_by(id: params[:profile_id])

    if @selected_profile
      @registers = @selected_profile
        .registers
        .where(date: start_date..end_date)
        .includes(:gemba, :profile)

      @total_earned = @registers.sum do |r|
        r.salary + ((r.extra_hour || 0) * (r.salary / 8.0 * 1.25)) + (r.extra_cost || 0)
      end
      @name = @selected_profile.name
      @total_active_employees = 1
      @total_worked_days = @registers.sum do |r|
        r.salary
      end
      @total_extra_hours = @registers.sum do |r|
        r.extra_hour * ((r.salary / 8.0) * 1.25)
      end
      @total_extra_cost = @registers.sum do |r|
        r.extra_cost || 0
      end
    else
      @registers = Register
        .where(date: start_date..end_date)
        .joins(:profile)
        .where(profiles: { company_id: company.id })
        .includes(:gemba, :profile)

      @total_earned = @registers.sum do |r|
        r.salary + ((r.extra_hour || 0) * (r.salary / 8.0 * 1.25)) + (r.extra_cost || 0)
      end
      @total_active_employees = @profiles.count { |p| p.active }
      @name = company.name
    end
      @total_extra_hour = @registers.sum(:extra_hour)
      @total_days = @registers.count

    if turbo_frame_request?
      render partial: "managements/details"
    end
  end
end
