class GembasController < ApplicationController
  def index
    @gembas = current_user.profiles.first.company.gembas.order(active: :desc, name: :asc)
  end

  def new
    @gemba = Gemba.new
  end

  def create
    @gemba = Gemba.new(gemba_params)
    @gemba.company = current_user.profiles.first.company
    if @gemba.save
      redirect_to new_gemba_path, notice: "Gemba criado com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def bulk_update
    active_ids = params[:gembas]&.keys || []

    Gemba.update_all(active: false)
    Gemba.where(id: active_ids).update_all(active: true)

    redirect_to gembas_path, notice: "Gembas atualizados com sucesso."
  end

  private

  def gemba_params
    params.require(:gemba).permit(:name)
  end
end
