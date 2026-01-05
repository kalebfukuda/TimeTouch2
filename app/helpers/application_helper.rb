module ApplicationHelper
  def month_year_list(from = 2000)
    start = Date.new(from, 1, 1)
    (start..Date.today).select { |d| d.day == 1 }
                      .map { |d| [d.strftime("%m/%Y"), d.strftime("%Y-%m")] }
                      .reverse
  end

  def year_list(from = 2024)
    current_year = Date.today.year
    (from..current_year).to_a.reverse
  end

  def month_list
    Date::MONTHNAMES.compact.each_with_index.map { |name, index| [name, index + 1] }
  end
end
