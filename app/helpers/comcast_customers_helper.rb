module ComcastCustomersHelper

  def comcast_customer_link(comcast_customer)
    return unless comcast_customer
    link_to comcast_customer.name, comcast_customer_url(comcast_customer)
  end

end
