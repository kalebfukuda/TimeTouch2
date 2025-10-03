class RegistersController < ApplicationController
  def create
    @register = Register.new(register_params)
    @register.profile = current_user.profiles.first
    if @register.save
      redirect_to main_path, notice: "Registro criado com sucesso!"
    else
      puts "ERROOOOOOOOOOOOOOOOOOOOOOOO"
      puts @register.errors.full_messages
      render "pages/main", status: :unprocessable_entity
    end
  end

  private

  def register_params
    params.require(:register).permit(:date, :extra_hour, :extra_cost, :gemba_id, :period_id)
  end
end
