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

  def this_week_commissions_chart
    line_chart ConnectOrderPayout.this_week.group("cast(dateordered as date)").sum(:payout), {
        id: 'this_week_sales_chart',
        library: {
            hAxis: { title: 'Day',
                     format: 'M/d'
            }
        }
    }
  end

  def training_chart
    data = [
        ['Trained', 471],
        ['Not Completed', 182],
        ['Not Started', 106]
    ]
    pie_chart data, {
        id: 'training_chart',
        colors: ['limegreen', 'yellow', '#f04124']
    }
  end

  def this_month_person_sales_chart(person)
    line_chart ConnectOrder.this_month.sales.where(connect_user: person.connect_user).group("cast(dateordered as date)").count, {
        id: 'this_month_person_sales_chart',
        library: {
            hAxis: { title: 'Day',
                     format: 'M/d'
            }
        }
    }
  end

  def this_month_person_hours_chart(person)
    line_chart ConnectTimesheet.this_month.where(connect_user: person.connect_user).group("cast(shift_date as date)").sum(:hours), {
        id: 'this_month_person_hours_chart',
        library: {
            hAxis: { title: 'Day',
                     format: 'M/d'
            }
        }
    }
  end
end
