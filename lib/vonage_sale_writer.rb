module VonageSaleWriter
  def create_and_update_all(sales)
    written_sales = Array.new
    for sale in sales do
      mark_existing_resold(sale)
      new_sale = VonageSale.new
      set_attributes(sale, new_sale)
      updated = new_sale.save
      unless new_sale.valid?
        puts "#{new_sale.persisted? ? 'PERSISTED' : 'NOT PERSISTED' }"
        puts sale.attributes.inspect
        puts new_sale.attributes.inspect
        puts new_sale.errors.full_messages.join(', ')
      end
      written_sales << new_sale if updated
    end
    written_sales
  end

  def mark_existing_resold(sale)
    existing_sale = VonageSale.find_by(mac: sale.mac) || return
    if existing_sale.connect_order
      existing_sale.update resold: true if existing_sale.connect_order != sale.connect_order
    end
  end

  def set_attributes(source, destination)
    destination.assign_attributes sale_date: source.sale_date,
                                  person: source.person,
                                  confirmation_number: source.confirmation_number,
                                  location: source.location,
                                  customer_first_name: source.customer_first_name,
                                  customer_last_name: source.customer_last_name,
                                  mac: source.mac,
                                  connect_order_uuid: source.connect_order_uuid,
                                  vonage_product: source.vonage_product
  end
end