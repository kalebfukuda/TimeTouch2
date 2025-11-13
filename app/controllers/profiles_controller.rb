class ProfilesController < ApplicationController
  def new
    @profile = Profile.new
  end

  def create
    @profile = Profile.new(profile_params)
    @profile.company = current_user.profiles.first.company
    if @profile.save
      redirect_to new_profile_path, notice: "Perfil criado com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:name, :salary, :can_drive, :role_id, :company_id)
  end
end
