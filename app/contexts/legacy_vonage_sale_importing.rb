class LegacyVonageSaleImporting
  def initialize(duration)
    @duration = duration
  end

  def import_for_date_range start_date, end_date, automated = false
    orders = sales_for_date_range start_date, end_date
    import_orders orders, automated
  end

  def import automated = false
    orders = sales_for_last @duration
    import_orders orders, automated
  end

  def import_orders orders, automated = false
    self.extend VonageLegacySaleTranslator
    sales = self.translate_all(orders)
    self.extend VonageSaleWriter
    self.create_and_update_all sales
    ProcessLog.create process_class: "LegacyVonageSaleImporting", records_processed: sales.count if automated
  end

  private

  def sales_for_date_range start_date, end_date
    ConnectOrder.
        where("dateordered >= ? AND dateordered <= ?", start_date, end_date.to_datetime.end_of_day).
        sales.
        includes(:connect_order_lines,
              :connect_business_partner,
              :connect_business_partner_location,
              :connect_user)
  end

  def sales_for_last(duration)
    ConnectOrder.updated_within_last(duration).sales.
        includes(:connect_order_lines,
              :connect_business_partner,
              :connect_business_partner_location,
              :connect_user)
  end
end