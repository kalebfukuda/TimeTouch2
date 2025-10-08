class SchedulesController < ApplicationController
  def index
    @today = Date.current
    @schedules = Schedule.joins(profile: :company)
                    .where(profiles: { company_id: current_user.profiles.first.company_id })
    @schedules_date = Schedule.where(date: @today, profile: current_user.profiles.first).first
    puts @schedules_date
  end

  def new
    @schedule = Schedule.new
  end

  def create
    start_date = Date.parse(params[:schedule][:from_date])
    end_date   = Date.parse(params[:schedule][:to_date])
    dates = (start_date..end_date).to_a

    profiles = params[:schedule][:profile_ids].reject(&:blank?).map(&:to_i)
    dates.each do |date|
      profiles.each do |profile_id|
        Schedule.create!(
          date: date,
          profile_id: profile_id,
          gemba_id: schedule_params[:gemba_id]
        )
      end
    end
    redirect_to schedules_path, notice: "Agenda criada com sucesso!"
  end

  def by_date
    date = Date.parse(params[:date])
    @schedules_date = Schedule.joins(profile: :company)
                      .where(date: date, profiles: { company_id: current_user.profiles.first.company_id })

    # Renderiza só a partial
    render partial: "scheduledetails", locals: { schedules: @schedules_date }
  end

  private

  def schedule_params
    params.require(:schedule).permit(:date, :gemba_id)
  end
end
