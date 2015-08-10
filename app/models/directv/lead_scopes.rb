module DirecTV::LeadScopes
  def setup_scopes
    default_scope {
      joins(:directv_customer).
          order('directv_customers.first_name, directv_customers.last_name')

    }

    scope :person, ->(person_id) {
      where('directv_customers.person_id = ?', person_id)
    }

    scope :overdue, -> {
      where(active: true).
          where('follow_up_by < ?', Date.current).
          order(:follow_up_by)
    }

    scope :upcoming, -> {
      where(active: true).
          where('follow_up_by >= ? AND follow_up_by <= ?',
                Date.current,
                Date.current + 1.week).order(:follow_up_by)
    }

    scope :not_upcoming_or_overdue, -> {
      where(active: true).
          where('follow_up_by > ? OR follow_up_by IS NULL',
                Date.current + 1.week)
    }
  end
end