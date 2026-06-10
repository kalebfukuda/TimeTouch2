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
    @schedule.week_days = [1, 2, 3, 4, 5, 6]
  end

  def create
    start_date = Date.parse(params[:schedule][:from_date])
    end_date   = Date.parse(params[:schedule][:to_date])
    week_days  = params[:schedule][:week_days].reject(&:blank?).map(&:to_i)
    dates = (start_date..end_date).to_a

    profiles = params[:schedule][:profile_ids].reject(&:blank?).map(&:to_i)

    template = <<~TEXT
                Olá $nome$! Nova agenda foi criada para o seguinte período:
                De: #{start_date.strftime('%d/%m/%Y')}
                Até: #{end_date.strftime('%d/%m/%Y')}
                Dias da semana: #{week_days.map { |d| Date::DAYNAMES[d] }.join(', ')}
                Periodo: #{Period.find(schedule_params[:period_id]).description}
                Atenciosamente,
                $nome_empresa$
                TEXT
    dates.each_with_index do |date, index|
      next unless week_days.include?(date.wday)

      profiles.each do |profile_id|
        Schedule.create!(
          date: date,
          profile_id: profile_id,
          gemba_id: schedule_params[:gemba_id],
          period_id: schedule_params[:period_id]
        )
        if index.zero? # Envia a mensagem apenas para a primeira data criada
          profile = Profile.find(profile_id)
          variables = {
            nome: profile.name,
            nome_empresa: profile.company.name
          }
          variables.each do |key, value|
            template.gsub!("$#{key}$", value.to_s)
          end
          Line::BroadcastService.send_to_user(Profile.find(profile_id).user, template)
        end
      end
    end
    redirect_to schedules_path, notice: "Agenda criada com sucesso!"
  end

  def by_date
    date = Date.parse(params[:date])
    @schedules_date = Schedule
                        .joins(:profile)
                        .where(date: date, profiles: { company_id: current_user.profiles.first.company_id })
                        .select('schedules.date, schedules.gemba_id,
                                array_agg(profiles.name) as profile_names,
                                array_agg(schedules.profile_id) as profile_ids')
                        .group('schedules.date, schedules.gemba_id')
                        .order('schedules.date, schedules.gemba_id')

    # Renderiza só a partial
    render partial: "scheduledetails", locals: { schedules: @schedules_date }
  end

  private

  def schedule_params
    params.require(:schedule).permit(:date, :gemba_id, :period_id)
  end
end
