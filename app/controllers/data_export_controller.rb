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

  # def month_export
  #   return unless request.post?
  #   records = Register.includes(:gemba)

  #   data = records.map do |r|
  #     [
  #       r.date.strftime('%Y-%m-%d'),
  #       r.gemba.name,
  #       r.value # or any numeric field you want to sum
  #     ]
  #   end

  #   total_sum = records.sum(:value)

  #   sheet = SpreadsheetArchitect.to_xlsx(
  #     header_style: { bold: true },
  #     data: data,
  #     footer_style: { bold: true },
  #     footer: ["TOTAL", "", total_sum]
  #   )

  #   send_data sheet,
  #     filename: "gemba_report.xlsx",
  #     type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
  # end

  private

  def export(sheet, filename, type)
    send_data sheet,
      filename: filename,
      type: type
  end
end
