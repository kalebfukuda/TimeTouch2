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
    package = Axlsx::Package.new
    workbook = package.workbook
    total_style = workbook.styles.add_style(
      bg_color: "FFFF00",
      b: true
    )
    month_year = params[:export][:month_year]
    profiles = params[:export][:profile_ids].reject(&:blank?).map(&:to_i)

    puts profiles.inspect
    begin_of_month = Date.parse("#{month_year}-01")
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
          ]
        else
          records_for_date.each do |r|
            if r.date == date
              data << [
                date.strftime('%Y-%m-%d'),
                r.gemba.name,
                r.period.description,
                r.salary,
                r.extra_cost || 0,
                r.extra_hour || 0,
                (r.salary + ((r.extra_hour * ((r.salary / 8) * 1.25)) || 0) + (r.extra_cost || 0))
              ]
              total_salary += r.salary
              total_extra_cost += r.extra_cost || 0
              total_extra_hour += (r.extra_hour * ((r.salary / 8) * 1.25)) || 0
            end
          end
        end
      end
      total_sum = total_salary + total_extra_cost + total_extra_hour

      data << ["TOTAL", "", "", total_salary, total_extra_cost, total_extra_hour, total_sum]


      workbook.add_worksheet(name: Profile.find(p).name) do |sheet|
        sheet.add_row ["Data", "Gemba", "Período", "Salario", "Gasto Extra", "Hora Extra", "Total"]
        # Renders the common lines
        data[0...-1].each do |row|
          sheet.add_row row
        end

        sheet.add_row data.last, style: total_style
      end
    end

    export(package.to_stream.read, "report.xlsx", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
  end

  private

  def export(sheet, filename, type)
    send_data sheet,
      filename: filename,
      type: type
  end
end
