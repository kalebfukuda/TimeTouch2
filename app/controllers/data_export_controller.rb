class DataExportController < ApplicationController
  def example_export
    sheet = SpreadsheetArchitect.to_xlsx(
      headers: ["Date", "Gemba", "Value"],
      data: [
        ["2025-01-01", "Gemba A", 10],
        ["2025-01-02", "Gemba B", 20],
        ["TOTAL", "", 30]
      ]
    )

    export(sheet, "report.xlsx", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
  end

  def month_export
    if params[:export][:month].blank? || params[:export][:year].blank?
      redirect_back(
        fallback_location: root_path,
        alert: "Mês e ano são obrigatórios"
      )
      return
    end
    package = Axlsx::Package.new
    workbook = package.workbook
    total_style = workbook.styles.add_style(
      bg_color: "FFFF00",
      b: true
    )
    month = params[:export][:month].to_i
    year = params[:export][:year].to_i
    profiles = params[:export][:profile_ids].reject(&:blank?).map(&:to_i)

    begin_of_month = Date.parse("#{year}-#{month}-01")
    end_of_month = begin_of_month.end_of_month

    profiles.each do |p|
      records = Register.joins(:gemba)
                      .where(gembas: {company_id: current_user.profiles.first.company}, registers: {date: begin_of_month..end_of_month, profile_id: p})
                      .includes(:profile)
                      .order(date: :asc)

      data = []
      total_salary = 0
      total_extra_cost = 0
      total_extra_hour = 0
      (begin_of_month..end_of_month).each do |date|
        records_for_date = records.select { |r| r.date == date }
        if records_for_date.empty?
          data << [
            date.strftime('%Y-%m-%d'),
            "",
            "",
            0,
            0,
            0,
            0,
            ""
          ]
        else
          records_for_date.each do |r|
            if r.date == date
              data << [
                date.strftime('%Y-%m-%d'),
                r.gemba.name + (r.register_status_id == 2 ? " (FALTA)" : ""),
                r.period.description,
                r.salary.to_i,
                r.extra_cost.to_i || 0,
                r.extra_hour.to_i || 0,
                (r.salary.to_i + ((r.extra_hour.to_i * ((r.salary.to_i / 8) * 1.25).round) || 0) + (r.extra_cost.to_i || 0)),
                r.note || ""
              ]
              total_salary += r.salary.to_i
              total_extra_cost += r.extra_cost.to_i || 0
              total_extra_hour += (r.extra_hour.to_i * ((r.salary.to_i / 8) * 1.25).round) || 0
            end
          end
        end
      end
      total_sum = total_salary + total_extra_cost + total_extra_hour

      data << ["TOTAL", "", "", total_salary, total_extra_cost, total_extra_hour, total_sum, ""]

      workbook.add_worksheet(name: Profile.find(p).name) do |sheet|
        sheet.add_row ["Data", "Gemba", "Período", "Salario", "Gasto Extra", "Hora Extra", "Total", "Observações"]
        data[0...-1].each do |row|
          sheet.add_row row
        end

        sheet.add_row data.last, style: total_style
      end
    end

    export(package.to_stream.read, "report.xlsx", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
  end

  def sekyusho_export
  package  = Axlsx::Package.new
  wb       = package.workbook
  s        = wb.styles

  # ── Estilos ──────────────────────────────────────────────────────────
  thin_border = { style: :thin, color: "FF000000" }

  st_titulo = s.add_style(
    font_name: "游ゴシック", sz: 18,
    bg_color: "deeaf6",
    alignment: { horizontal: :center, vertical: :center },
    border: { style: :thin, color: "FF000000", edges: [:top, :bottom, :left, :right] }
  )

  st_data = s.add_style(
    font_name: "游ゴシック", sz: 12,
    alignment: { horizontal: :center, vertical: :center }
  )

  st_advice = s.add_style(
    font_name: "游ゴシック", sz: 12,
    alignment: { horizontal: :center, vertical: :center },
    border: { style: :thin, color: "FF000000", edges: [:top, :bottom, :left, :right] }
  )

  st_client = s.add_style(
    font_name: "游ゴシック", sz: 16, b: true,
    alignment: { horizontal: :center, vertical: :center },
    border: { style: :thin, color: "FF000000", edges: [:top, :bottom, :left, :right] }
  )

  st_field = s.add_style(
    font_name: "游ゴシック", sz: 12, b: true,
    alignment: { horizontal: :center, vertical: :center },
    bg_color: "deeaf6",
    border: { style: :thin, color: "FF000000", edges: [:top, :bottom, :left, :right] }
  )

  st_response = s.add_style(
    font_name: "游ゴシック", sz: 12,
    alignment: { horizontal: :left, vertical: :center },
    border: { style: :thin, color: "FF000000", edges: [:top, :bottom, :left, :right] }
  )

  st_response_borderless = s.add_style(
    font_name: "游ゴシック", sz: 12,
    alignment: { horizontal: :center, vertical: :center }
  )

  st_response_center = s.add_style(
    font_name: "游ゴシック", sz: 12,
    alignment: { horizontal: :center, vertical: :center, wrap_text: true },
    border: { style: :thin, color: "FF000000", edges: [:top, :bottom, :left, :right] }
  )

  st_header_timesheet = s.add_style(
    font_name: "游ゴシック", sz: 10, b: true,
    alignment: { horizontal: :center, vertical: :center },
    bg_color: "cfd6e0",
    border: { style: :thin, color: "FF000000", edges: [:top, :bottom, :left, :right] }
  )

  wb.add_worksheet(name: "請求書") do |sheet|

    # Row 1 — vazia (margem)
    sheet.add_row []
    # Row 2 — vazia (margem)
    sheet.add_row []

    # Row 3 — Título 請求書 (B:H)
    sheet.add_row [nil, "請求書", nil, nil, nil, nil, nil, nil],
      style: [nil, st_titulo, st_titulo, st_titulo,
              st_titulo, st_titulo, st_titulo, st_titulo],
      height: 36
    sheet.merge_cells("B3:H3")

    # Row 4 — Data (B:D)
    sheet.add_row [nil, nil, nil, nil, nil, nil, "請求日 令和8年5月31日", nil],
      style:[nil, nil, nil, nil, nil, nil, st_data, nil],
      height: 24
    sheet.merge_cells("G4:H4")

    # Row 5/6 — Cliente (B:H)
    sheet.add_row [nil, "株式会社鎌川電気", nil, nil, nil, nil, nil, nil],
      style: [nil, st_client, st_client, st_client, st_client, st_client, st_client, st_client],
      height: 28
    sheet.add_row [nil, nil, nil, nil, nil, nil, nil, nil],
      style: [nil, st_client, st_client, st_client, st_client, st_client, st_client, st_client],
      height: 28
    sheet.merge_cells("B5:H6")

    # Row 7 - Pedido (B:H)
    sheet.add_row [nil, "下記のとおり、御請求申し上げます", nil, nil, nil, nil, nil, nil],
      style: [nil, st_advice, nil, nil, nil, nil, nil, nil],
      height: 24
    sheet.merge_cells("B7:H7")

    # Row 8 - Nome funcionário (B:H)
    sheet.add_row [nil, current_user.name, nil, nil, nil, nil, nil, nil],
      style: [nil, st_titulo, nil, nil, nil, nil, nil, nil],
      height: 36
    sheet.merge_cells("B8:H8")

    # Row 9 - 件名 (B:H)
    sheet.add_row [nil, "件名", current_user.name, nil, "〒210-0834", nil, nil, nil],
      style: [nil, st_field, st_response_center, nil, st_response_center, nil, nil, nil],
      height: 36
    sheet.merge_cells("C9:D9")
    sheet.merge_cells("E9:H9")

    # Row 10/11/12 - 振込先　 (B:H)
    sheet.add_row [nil, "振込先", "ゆうちょ銀行", nil, "川崎市川崎区大島1丁目10番1号ラ・シュール２０１", nil, nil, nil],
      style: [nil, st_field, st_response_borderless, nil, st_response_center, nil, nil, nil],
      height: 28
    sheet.add_row [nil, nil, "支店〇九八", nil, nil, nil, nil, nil],
      style: [nil, nil, st_response_borderless, nil, nil, nil, nil, nil],
      height: 28
    sheet.add_row [nil, nil, "普通1236467", nil, nil, nil, nil, nil],
      style: [nil, nil, st_response_borderless, nil, nil, nil, nil, nil],
      height: 28
    sheet.merge_cells("B10:B12")
    sheet.merge_cells("C10:D10")
    sheet.merge_cells("E10:H10")
    sheet.merge_cells("C11:D11")
    sheet.merge_cells("C12:D12")
    sheet.merge_cells("E10:H12")

    # Row 13 - 合計 (B:H) TOTAL
    sheet.add_row [nil, "合計", "TOTAL 780.000", nil, "TEL", "080-6452-0392", nil, nil],
      style: [nil, st_field, st_response_center, nil, st_field, st_response_center, nil, nil],
      height: 28
    sheet.merge_cells("C13:D13")
    sheet.merge_cells("F13:H13")

    # Row 14/15/16 - 印 (B:H) Imprimir
    sheet.add_row [nil, nil, nil, nil, nil, nil, nil, "印"],
      style: [nil, nil, nil, nil, nil, nil, nil, st_response_center],
      height: 28
    sheet.add_row [],
      height: 28
    sheet.add_row [],
      height: 28
    sheet.merge_cells("H14:H16")

    # Row 17 empty (B:H)
    sheet.add_row []

    # TOTAIS
    # Row 18
    sheet.add_row [nil, "摘要", nil, nil, nil, "単価", "日当数", "金額"],
      style: [nil, st_field, nil, nil, nil, st_field, st_field, st_field]
    sheet.merge_cells("B18:E18")


    total_row_start = 19
    start_date = Date.new(2026, 6).beginning_of_month
    end_date   = Date.new(2026, 6).end_of_month
    result = Register
    .joins(:gemba, :profile)
    .where(profiles: { user_id: current_user.id })
    .where(date: start_date..end_date)
    .order("gembas.name, registers.date")
    .select(
      "registers.date,
      registers.salary,
      registers.extra_cost,
      registers.extra_hour,
      gembas.name,
      registers.gemba_id"
    )
    # result = Register
    #   .joins(:gemba, :profile)
    #   .where(profiles: { user_id: current_user.id })
    #   .where(date: Date.new(2026, 6).beginning_of_month..Date.new(2026, 6).end_of_month)
    #   .group("registers.gemba_id, gembas.name, registers.salary")
    #   .select(
    #     "registers.gemba_id,
    #     gembas.name AS gemba_name,
    #     COUNT(*) AS days_count,
    #     SUM(registers.salary) AS total_amount,
    #     registers.salary as salary_per_day"
    #   )

    total_dias = result.size
    total_transport = result.sum(&:extra_cost)
    total_extra_hours = result.sum(&:extra_hour)
    # Agrupar por gemba_id para calcular totais por gemba
    result_by_gemba = result.group_by(&:gemba_id)
    result_by_gemba.each do |gemba_id, registers|
      first = registers.first
      days_count   = registers.count
      total_salary = registers.sum(&:salary)
      total_transport = registers.sum(&:extra_cost)
      total_extra_hours = registers.sum(&:extra_hour)

      # Linha do gemba (salário)
      sheet.add_row [nil, first.gemba.name, nil, nil, nil, first.salary, days_count, total_salary],
        style: [nil, st_response_center, nil, nil, nil, st_response_center, st_response_center, st_response_center]
      sheet.merge_cells("B#{total_row_start}:E#{total_row_start}")
      total_row_start += 1

       # Linha de transporte
      # sheet.add_row [nil, "交通費", nil, nil, nil, " - " , days_count, total_transport],
      #   style: [nil, st_response_center, nil, nil, nil, st_response_center, st_response_center, st_response_center]
      # sheet.merge_cells("B#{total_row_start}:E#{total_row_start}")
      # total_row_start += 1

      # # Linha de hora extra
      # sheet.add_row [nil, "残業", nil, nil, nil, (first.salary / 8) * 1.25, total_dias, total_extra_hours],
      #   style: [nil, st_response_center, nil, nil, nil, st_response_center, st_response_center, st_response_center]
      # sheet.merge_cells("B#{total_row_start}:E#{total_row_start}")
      # total_row_start += 1
    end

    # Transporte
    sheet.add_row [nil, "交通費", nil, nil, nil, " - ", total_dias, total_transport],
      style: [nil, st_response_center, nil, nil, nil, st_response_center, st_response_center, st_response_center]
    sheet.merge_cells("B#{total_row_start}:E#{total_row_start}")
    total_row_start += 1

    # Hora extra
    total_extra_h = result.sum(&:extra_hour)
    sheet.add_row [nil, "残業", nil, nil, nil, (result.first.salary / 8) * 1.25, total_extra_h, total_extra_hours],
      style: [nil, st_response_center, nil, nil, nil, st_response_center, st_response_center, st_response_center]
    sheet.merge_cells("B#{total_row_start}:E#{total_row_start}")
    total_row_start += 1

    # Subtotal
    sheet.add_row [nil, nil, nil, nil, nil, "小計", nil, result.sum(&:salary)],
      style: [nil, nil, nil, nil, nil, st_field, st_response_center, st_response_center]
    sheet.merge_cells("F#{total_row_start}:G#{total_row_start}")
    total_row_start += 1

    # TOTAL
    sheet.add_row [nil, nil, nil, nil, nil, "合計", nil, result.sum(&:salary) + total_transport + total_extra_hours],
      style: [nil, nil, nil, nil, nil, st_field, st_response_center, st_response_center]
    sheet.merge_cells("F#{total_row_start}:G#{total_row_start}")
    total_row_start += 1

    # Row empty (B:H)
    sheet.add_row []
    total_row_start += 1

    # Timesheet (B:H)
    sheet.add_row [nil, current_user.name, nil, nil, nil, nil, nil, nil, nil, nil, "Diaria"],
      style: [nil, st_field, nil, nil, nil, nil, nil, nil, nil, nil, st_field]
    sheet.merge_cells("B#{total_row_start}:J#{total_row_start}")
    total_row_start += 1

    # Timesheet (B:H) header
    sheet.add_row [nil, "Dia", "Local", nil, "Zangyou", nil, "Ida", "Volta", "Estacionamento", "Gasolina", result.first.salary],
      style: [nil, st_header_timesheet, st_header_timesheet, nil, st_header_timesheet, nil, st_header_timesheet, st_header_timesheet, st_header_timesheet, st_header_timesheet, st_response_center]
    sheet.merge_cells("C#{total_row_start}:D#{total_row_start}")
    sheet.merge_cells("E#{total_row_start}:F#{total_row_start}")
    total_row_start += 1

    # Timesheet (B:H) data
    registers_by_date = result.index_by { |r| r.date.to_date }
    (start_date..end_date).each do |day|
      register = registers_by_date[day]

      if register
        sheet.add_row [
          nil,
          day.strftime("%d/%m/%Y"),
          register.gemba.name, nil,
          register.extra_hour, nil,
          register.extra_cost, nil,
          #register.parking_cost,
          0,
          #register.gas_cost,
          0]
      else
        sheet.add_row [nil, day.strftime("%d/%m/%Y"), nil, nil, nil, nil, nil, nil, nil, nil]
      end
      sheet.merge_cells("C#{total_row_start}:D#{total_row_start}")
      sheet.merge_cells("E#{total_row_start}:F#{total_row_start}")
      total_row_start += 1
    end
    # Define o tamanho das colunas
      sheet.column_widths 12, 12, 12, 12, 12, 12, 12, 12, 14, 12, 12
  end
  export(
    package.to_stream.read,
    "sekyusho_test.xlsx",
    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
  )
end

  private

  def export(sheet, filename, type)
    send_data sheet,
      filename: filename,
      type: type
  end
end
