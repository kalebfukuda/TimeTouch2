class ProfilesController < ApplicationController
  def new
    @profile = Profile.new
  end

  def create
    @profile = Profile.new(profile_params)
    @profile.user_id = current_user.id
    @profile.active = true
    if @profile.save
      redirect_to main_path, notice: "Perfil criado com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @profile = Profile.find(params[:id])
  end

  def update
    @profile = Profile.find(params[:id])
    salary_changed = @profile.salary != profile_params[:salary].to_f

    safe_params = profile_params
    safe_params = profile_params.except(:date_start_salary) unless salary_changed
    if @profile.update(safe_params)
      redirect_to main_path, notice: "Perfil atualizado com sucesso!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:name, :salary, :can_drive, :role_id, :company_id, :active, :date_start_salary, :locale)
  end
end
