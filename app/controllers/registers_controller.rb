class RegistersController < ApplicationController
  def create
    old_register = Register.where(date: params[:register][:date],
                                    profile: current_user.profiles.first,
                                    period_id: params[:register][:period_id])

    @register = Register.new(register_params)
    @register.profile = current_user.profiles.first

    if old_register.exists? && params[:register][:duplicated_register] != "true"
      puts "--------------------------------" + params[:register][:date]
      flash.now[:confirm_required] = true
      prepare_collections
      render "pages/main", status: :unprocessable_entity
      return
    end

    # If confirmed to duplicate, delete old register
    if params[:register][:duplicated_register] == "true"
      old_register.destroy_all
    end



    dt_start = @register.profile.date_start_salary || Date.new(1900, 1, 1)


    if (params[:register][:date].to_date < dt_start)
      @register.salary = @register.profile.previous_salary
    else
      @register.salary = @register.profile.salary
    end

    if @register.save
      redirect_to main_path, notice: "Registro criado com sucesso!"
    else
      prepare_collections
      render "pages/main", status: :unprocessable_entity
    end
  end

  private

  def register_params
    params.require(:register).permit(:date, :extra_hour, :extra_cost, :gemba_id, :period_id, :note)
  end

  def prepare_collections
    profile = current_user.profiles.first
    @registers  = Register.where(profile: profile).order(date: :desc)
    @schedule   = Schedule.find_by(date: Date.current, profile: profile)
    @schedules  = Schedule.where(profile: profile).order(date: :desc)
  end
end
