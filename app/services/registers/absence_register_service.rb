module Registers
  class AbsenceRegisterService
    def initialize(user:, date:, note: nil )
      @user   = user
      @date   = date
      @note = note
    end

    def call
      # Busca register existente ou cria novo
      register = Register.find_or_initialize_by(
        profile: @user.profile,
        date:    @date
      )
      schedule_info = find_schedule_info

      register.assign_attributes(
        register_status_id: 2,
        note:  @note,
        gemba_id:        schedule_info[:gemba_id],
        period_id:       schedule_info[:period_id]
      )

      Rails.logger.debug("[AbsenceRegisterService] valid? #{register.valid?}")
      Rails.logger.debug("[AbsenceRegisterService] errors: #{register.errors.full_messages}")
      Rails.logger.debug("[AbsenceRegisterService] attributes: #{register.attributes}")

      if register.save
        Rails.logger.info("[Registers::AbsenceRegisterService] Falta registrada — user: #{@user.id}, date: #{@date}")
        true
      else
        Rails.logger.error("[Registers::AbsenceRegisterService] Erro ao salvar: #{register.errors.full_messages}")
        false
      end
    end

    private

    def find_schedule_info
      schedule = @user.profile.schedules.find_by(date: @date)

      if schedule
        { gemba_id: schedule.gemba_id, period_id: schedule.period_id }
      else
        last_register = @user.profile.registers.order(created_at: :desc).first
        {
          gemba_id:  last_register&.gemba_id,
          period_id: last_register&.period_id || 1
        }
      end
    end
  end
end
