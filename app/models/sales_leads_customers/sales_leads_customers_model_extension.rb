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

  def no_future_sales
    return unless self.order_date
    if self.order_date.to_date > Date.today
      errors.add(:order_date, 'cannot be in the future')
    end
  end
end