module DirecTV::SalesAndLeads

  private

  def directv_customer_name
    self.directv_customer.name
  end

  def directv_customer_mobile_phone
    self.directv_customer.mobile_phone
  end

  def directv_customer_other_phone
    self.directv_customer.other_phone
  end

end