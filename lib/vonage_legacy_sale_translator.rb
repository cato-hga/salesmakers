module VonageLegacySaleTranslator
  def translate_all(orders)
    @unmatched_sales = []
    sales = Array.new
    orders.each do |order|
      sale = translate(order)
      sales << sale if sale.valid?
    end
    send_unmatched
    sales.uniq
  end

  def translate(order)
    @order = order
    sale = VonageSale.new sale_date: get_sale_date,
                          person: get_person,
                          confirmation_number: get_confirmation_number,
                          location: get_location,
                          customer_first_name: get_customer_first_name,
                          customer_last_name: get_customer_last_name,
                          mac: get_mac,
                          vonage_product: get_vonage_product,
                          connect_order_uuid: order.c_order_id,
                          created_at: order.created.apply_eastern_offset,
                          updated_at: order.updated.apply_eastern_offset,
                          gift_card_number: (order.description.blank? ? nil : order.description.strip),
                          person_acknowledged: true,
                          creator: get_creator
    sale.import = true
    add_to_unmatched(order, sale) unless sale.valid?
    sale
  end

  def get_sale_date
    @order.dateordered.apply_eastern_offset.to_date
  end

  def get_person
    Person.return_from_connect_user @order.connect_user
  end

  def get_creator
    Person.return_from_connect_user @order.creator
  end

  def get_confirmation_number
    order_lines = @order.connect_order_lines ||= []
    order_lines.first ? order_lines.first.description : nil
  end

  def get_location
    customer_location = @order.connect_business_partner_location
    return unless customer_location
    c_bpl = ConnectBusinessPartnerLocation.
        find_by c_bpartner_location_id: customer_location.name
    return unless c_bpl
    Location.return_from_connect_business_partner_location c_bpl
  end

  def get_customer_first_name
    @customer = @order.connect_business_partner
    return unless @customer
    @customer.name.split[0]
  end

  def get_customer_last_name
    return unless @customer
    @customer.name.split[-1]
  end

  def get_mac
    return unless @order.documentno and @order.documentno.length == 16
    mac = @order.documentno.upcase[3..15]
    return unless mac[-1] == '+'
    mac[0..11]
  end

  def get_vonage_product
    order_lines = @order.connect_order_lines
    return unless order_lines.first and order_lines.first.connect_product
    product_name = order_lines.first.connect_product.name
    VonageProduct.find_by name: product_name
  end

  def unmatched_sales
    @unmatched_sales
  end

  private

  def add_to_unmatched(order, sale)
    @unmatched_sales << {
        order: order,
        reason: sale.errors.full_messages.join(', ')
    }
  end

  def send_unmatched
    unmatched = self.unmatched_sales || return
    UnmatchedVonageSalesMailer.unmatched_sales(unmatched).deliver_later
  end
end