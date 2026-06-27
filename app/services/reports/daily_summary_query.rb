module Reports
  class DailySummaryQuery
    def initialize(company:, date: Date.today)
      @company = company
      @date = date
    end

    def call
      {
        date: @date,
        scheduled:total_scheduled,
        present:total_present,
        #absent:total_absent,
        morning_count: total_morning_count,
        night_count: total_night_count,
      }
    end

    private

    def total_scheduled
      @company.schedules.where(date: @date).count
    end

    def total_present
      @company.registers.where(date: @date).count
    end

    def total_absent
      # TODO: adicionar status de ausencia/presenca no registro
      @company.registers.where(date: @date, status: 'absent').count
    end

    def total_morning_count
      @company.registers.where(date: @date, period_id: 1).count
    end

    def total_night_count
      @company.registers.where(date: @date, period_id: 2).count
    end
  end
end
