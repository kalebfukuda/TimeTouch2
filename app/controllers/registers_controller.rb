class RegistersController < ApplicationController
  def create
    old_register = Register.where(date: params[:register][:date],
                                  profile: current_user.profiles.first,
                                  period_id: params[:register][:period_id])

    @register = Register.new(register_params)
    @register.profile = current_user.profiles.first

    if old_register.exists? && params[:register][:duplicated_register] != "true"
      flash.now[:confirm_required] = true
      prepare_collections
      render "pages/main", status: :unprocessable_entity
      return
    end
    # Default register status is 1 (present)
    @register.register_status_id = 1

    # If confirmed to duplicate, delete old register
    ActiveRecord::Base.transaction do
      old_register.destroy_all if params[:register][:duplicated_register] == "true"
      @register.save!
    end

    dt_start = @register.profile.date_start_salary || Date.new(1900, 1, 1)

    if params[:register][:custom_value] == "1" && params[:register][:custom_salary].present?
      @register.salary = params[:register][:custom_salary].to_i
    elsif @register.date.present? && @register.date < dt_start
      @register.salary = @register.profile.previous_salary
    else
      @register.salary = @register.profile.salary
    end

    # Batimento comum é feito

    if @register.save
      redirect_to main_path, notice: "Registro criado com sucesso!"
    else
      prepare_collections
      render "pages/main", status: :unprocessable_entity
    end
  end

  private

  def register_params
    params.require(:register).permit(
      :date,
      :extra_hour,
      :extra_cost,
      :gemba_id,
      :period_id,
      :note,
      :custom_value,
      :custom_salary,
      :register_status_id
    )
  end

  def prepare_collections
    profile = current_user.profiles.first
    current_month = (params[:register][:date]&.to_date || Date.current)
    range = current_month.beginning_of_month.beginning_of_week..
            current_month.end_of_month.end_of_week

    @registers  = Register.where(profile: profile, date: range)
    @schedule   = Schedule.find_by(date: Date.current, profile: profile)
    @schedules  = Schedule.where(profile: profile, date: range).includes(:gemba, :period)

    @registers_by_date = @registers.group_by { |r| r.date.to_date }
    @schedules_by_date = @schedules.group_by { |s| s.date.to_date }
  end
end
