module WidgetsHelper

  def this_week_sales_chart
    line_chart ConnectOrder.this_week.sales.group("cast(dateordered as date)").count, {
        id: 'this_week_sales_chart',
        library: {
           hAxis: { title: 'Day',
                    format: 'M/d'
          }
        }
    }
  end

  def this_month_sales_chart
    line_chart ConnectOrder.this_month.sales.group("cast(dateordered as date)").count, {
        id: 'this_month_sales_chart',
        library: {
            hAxis: { title: 'Day',
                     format: 'M/d'
            }
        }
    }
  end

  def this_month_hours_chart
    line_chart ConnectTimesheet.this_month.group("cast(shift_date as date)").sum(:hours), {
        id: 'this_month_hours_chart',
        library: {
            hAxis: { title: 'Day',
                     format: 'M/d'
            }
        }
    }
  end
end
