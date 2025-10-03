class GembasController < ApplicationController
  def new
    @gemba = Gemba.new
  end

  def create
    @gemba = Gemba.new(gemba_params)
    if @gemba.save
      redirect_to new_gemba_path, notice: "Gemba criado com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def gemba_params
    params.require(:gemba).permit(:name)
  end
end
