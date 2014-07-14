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
        colors: ['#43ac6a', 'yellow', '#f04124'] #TODO: Fix text color on yellow
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

  def person_pnl_chart
    revenue = [['07/07/2014', 100],['07/08/2014', 50], ['07/09/2014', 25]]
    commissions = [['07/07/2014', 10],['07/08/2014', 5], ['07/09/2014', 15]]
    wages = [['07/07/2014', 25],['07/08/2014', 15], ['07/09/2014', 10]]
    data = [
        {name: 'Revenue', data: revenue},
        {name: 'Commissions', data: commissions},
        {name: 'Wages', data: wages}
    ]
    area_chart data, {
        id: 'pnl_chart',
        colors: ['limegreen', 'yellow', '#f04124'],
        library: {
            isStacked: false,
            hAxis: { title: 'Day',
                     format: 'M/d'
            }
        }
    }
  end

  def hps

  end

  def person_hps_chart(person)
    line_chart ConnectOrder.this_month.sales.where(connect_user: person.connect_user).group("cast(dateordered as date)").count, {
        id: 'this_month_person_hps_chart',
        library: {
            hAxis: { title: 'Day',
                     format: 'M/d'
            }
        }
    }
  end

end
