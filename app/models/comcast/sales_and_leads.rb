module Comcast::SalesAndLeads

  def rgus
    rgus = 0
    [self.tv?, self.internet?, self.phone?, self.security?].each { |rgu| rgus += (rgu ? 1 : 0) }
    rgus
  end

  def link
    return '' unless self.comcast_customer
    if Rails.env.staging? || Rails.env.production?
      Rails.application.routes.url_helpers.comcast_customer_url(self.comcast_customer)
    else
      Rails.application.routes.url_helpers.comcast_customer_url(self.comcast_customer, host: 'localhost:3000')
    end
  end

  def entered_by_name
    return unless self.person
    self.person.display_name
  end

  private

  def comcast_customer_name
    self.comcast_customer.name
  end

  def comcast_customer_mobile_phone
    self.comcast_customer.mobile_phone
  end

  def comcast_customer_other_phone
    self.comcast_customer.other_phone
  end

  def one_service_selected
    unless self.tv? or self.internet? or self.phone? or self.security?
      [:tv, :internet, :phone, :security].each do |product|
        errors.add(product, 'or at least one other product must be selected')
      end
    end
  end
end