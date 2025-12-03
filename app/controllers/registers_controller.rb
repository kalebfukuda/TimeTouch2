class RegistersController < ApplicationController
  def create
    @register = Register.new(register_params)
    @register.profile = current_user.profiles.first

    dt_start = @register.profile.date_start_salary || Date.new(1900, 1, 1)

    if (params[:register][:date].to_date < dt_start)
      @register.salary = @register.profile.previous_salary
    else
      @register.salary = @register.profile.salary
    end

    if @register.save
      redirect_to main_path, notice: "Registro criado com sucesso!"
    else
      @registers = Register.where(profile: current_user.profiles.first).order(date: :desc)
      @schedule = Schedule.find_by(date: Date.current, profile: current_user.profiles.first)
      render "pages/main", status: :unprocessable_entity
    end
  end

  private

  def register_params
    params.require(:register).permit(:date, :extra_hour, :extra_cost, :gemba_id, :period_id)
  end
end
