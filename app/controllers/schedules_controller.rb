class SchedulesController < ApplicationController
  def index
    @today = Date.current
    @schedules = Schedule.where(profile: current_user.profiles.first).order(date: :desc)
    @schedules_date = Schedule.where(date: @today, profile: current_user.profiles.first).first
    puts @schedules_date
  end


  def new
    @schedule = Schedule.new
  end

  def create
    @schedule = Schedule.new(schedule_params)
    @schedule.profile = current_user.profiles.first
    if @schedule.save
      redirect_to new_schedule_path, notice: "Agenda criada com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def by_date
    date = Date.parse(params[:date])
    @schedules_date = Schedule.where(date: date).order(:date)

    # Renderiza só a partial
    render partial: "scheduledetails", locals: { schedules: @schedules_date }
  end

  private

  def schedule_params
    params.require(:schedule).permit(:date, :gemba_id)
  end
end
