module DirecTV::SaleScopes
  def set_scopes
    default_scope {
      joins(:person, :directv_install_appointment).
          order('directv_install_appointments.install_date DESC, people.display_name ASC')
    }
    scope :person, ->(person_id) {
      where(person_id: person_id)
    }

    scope :recent_installations, -> {
      installations_for_range(Date.today, Date.today - 8.days)
    }

    scope :upcoming_installations, -> {
      installations_for_range(Date.today + 1.week, Date.yesterday)
    }

    scope :installations_for_range, ->(is_less_than, is_greater_than) {
      joins(:directv_install_appointment).
          where('directv_install_appointments.install_date < ?',
                is_less_than).
          where('directv_install_appointments.install_date > ?',
                is_greater_than).
          order('directv_install_appointments.install_date')
    }

    scope :sold_between_dates, ->(start_date, end_date) {
      return none unless start_date and end_date
      where('order_date >= ? AND order_date < ?', start_date, end_date)
    }
  end
end