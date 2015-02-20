module SalesHelperExtension
  def past_month_sales_chart(day_sales_counts)
    content_tag :div,
                #link_to('Show/Hide Chart', '#', class: 'toggle_chart') +
                sales_line_chart(day_sales_counts),
                class: 'chart_container'
  end

  def sales_line_chart(day_sales_counts)
    line_chart day_sales_counts.
                   for_range((Date.today - 1.month)..Date.today).
                   group_by_day(:day).sum(:sales)
  end

  #:nocov:
  # IT'S JUST MATH, people
  def week_run_rate_multiplier
    1.week.seconds / (Time.zone.now - Time.zone.now.beginning_of_week)
  end

  def month_run_rate_multiplier
    number_of_days_in_month.days.seconds / (Time.zone.now - Time.zone.now.beginning_of_month)
  end

  def year_run_rate_multiplier
    number_of_days_in_year.days.seconds / (Time.zone.now - Time.zone.now.beginning_of_year)
  end

  def number_of_days_in_month
    Date.today.beginning_of_month + 1.month - Date.today.beginning_of_month
  end

  def number_of_days_in_year
    Date.today.beginning_of_year + 1.year - Date.today.beginning_of_year
  end

  def rank_label(rank)
    is_integer = rank.is_a?(Integer) ? true : false
    rank = rank.to_s
    rank = '#' + rank if is_integer
    ' '.html_safe + content_tag(:span, rank, class: [:label, :round, :secondary])
  end
end