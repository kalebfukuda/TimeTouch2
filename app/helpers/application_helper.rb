module ApplicationHelper
  def month_year_list(from = 2000)
    start = Date.new(from,1,1)
    (start..Date.today).select { |d| d.day == 1 }
                      .map { |d| [d.strftime("%b/%Y"), d.strftime("%Y-%m")] }
                      .reverse
  end
end
