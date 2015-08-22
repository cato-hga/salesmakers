module VonageSaleWriter
  def create_and_update_all(sales)
    written_sales = Array.new
    for sale in sales do
      updated_sale = new_or_existing(sale)
      set_attributes(sale, updated_sale)
      updated = updated_sale.save
      unless updated_sale.valid?
        puts "#{updated_sale.persisted? ? 'PERSISTED' : 'NOT PERSISTED' }"
        puts sale.attributes.inspect
        puts updated_sale.attributes.inspect
        puts updated_sale.errors.full_messages.join(', ')
      end
      written_sales << updated_sale if updated
    end
    written_sales
  end

  def new_or_existing(sale)
    VonageSale.find_by(mac: sale.mac) || VonageSale.new
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
                                  vonage_product: source.vonage_product,
                                  gift_card_number: source.gift_card_number,
                                  person_acknowledged: true,
                                  creator: source.creator
  end
end