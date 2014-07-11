module WidgetsHelper

  def this_week_sales_chart
    line_chart ConnectOrder.this_week.sales.group("cast(dateordered as date)").count, {
               library: {
                   hAxis: { title: 'Day',
                            format: 'M/d'
                  }
               }
    }
  end

  def this_month_sales_chart
    line_chart ConnectOrder.this_month.sales.group("cast(dateordered as date)").count, {
        library: {
            hAxis: { title: 'Day',
                     format: 'M/d'
            }
        }
    }
  end
end
