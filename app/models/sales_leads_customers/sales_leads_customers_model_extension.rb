module SalesLeadsCustomersModelExtension

  def name
    NameCase([self.first_name, self.last_name].join(' '))
  end

  private

  def within_24_hours
    return unless self.order_date
    if self.order_date.to_date < Date.today - 1.day
      errors.add(:order_date, 'cannot be more than 24 hours in the past')
    end
  end

  def deactivate_old_lead(project)
    if self.overdue_by_thirty_five
      self.update active: false
      dismissal_reason_project_sym = Object.const_get "#{project}LeadDismissalReason"
      dismissal_reason_sym = ("#{project.downcase}_lead_dismissal_reason")
      customer_sym = ("#{project.downcase}_customer")
      reason = dismissal_reason_project_sym.find_by name: '35 days without follow up'
      self.send(customer_sym).dismissal_reason_sym = reason
      self.send(customer_sym).dismissal_comment = 'Auto-closed after 35 days of inactivity'
      admin = Person.find_by email: 'retailingw@retaildoneright.com'
      admin.log? 'destroy',
                 self,
                 admin,
                 nil,
                 nil
    end
  end

  def no_future_sales
    return unless self.order_date
    if self.order_date.to_date > Date.today
      errors.add(:order_date, 'cannot be in the future')
    end
  end
end
