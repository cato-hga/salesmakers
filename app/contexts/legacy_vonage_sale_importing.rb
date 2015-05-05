class LegacyVonageSaleImporting
  def initialize(duration)
    @duration = duration
  end

  def import
    orders = sales_for_last(@duration)
    self.extend VonageLegacySaleTra nslator
    sales = self.translate_all(orders)
    self.extend VonageSaleWriter
    self.create_and_update_all sales
  end

  private

  def sales_for_last(duration)
    ConnectOrder.updated_within_last(duration).sales.
        includes(:connect_order_lines,
              :connect_business_partner,
              :connect_business_partner_location,
              :connect_user)
  end
end