class RegistersController < ApplicationController
  def create
    @register = Register.new(register_params)
    @register.profile = current_user.profiles.first

    @register.extra_hour = 0.0 unless params[:extra_hour].present?
    @register.extra_cost = 0 unless params[:extra_cost].present?

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
