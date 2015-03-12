class LegacyVonageSaleImporting
  def initialize(duration)
    @duration = duration
    @current_paycheck = current_paycheck
  end

  def import
    orders = sales_for_last(@duration)
    self.extend VonageLegacySaleTranslator
    sales = self.translate_all(orders)
    self.extend VonageSaleWriter
    self.create_and_update_all sales
  end

  def clear_resold_devices
    return unless @current_paycheck
    resales = resold_for_last(@duration)
    for resale in resales do
      vonage_sale = VonageSale.find_by(connect_order: resale) || next
      clear_current_paycheck_payouts(vonage_sale)
      vonage_sale.update resold: true
    end
  end

  private

  def sales_for_last(duration)
    ConnectOrder.updated_within_last(duration).sales.
        includes(:connect_order_lines,
              :connect_business_partner,
              :connect_business_partner_location,
              :connect_user)
  end

  def resold_for_last(duration)
    ConnectOrder.updated_within_last(duration).resales.
        includes(:connect_order_lines,
                 :connect_business_partner,
                 :connect_business_partner_location,
                 :connect_user)
  end

  def clear_current_paycheck_payouts(vonage_sale)
    return if vonage_sale.vonage_sale_payouts.empty?
    for payout in vonage_sale.vonage_sale_payouts do
      next unless payout_in_current_check?(payout)
      payout.destroy
    end
  end

  def payout_in_current_check?(payout)
    payout.vonage_paycheck == @current_paycheck
  end

  def current_paycheck
    paychecks = VonagePaycheck.where('cutoff >= ?',
                                     DateTime.now).order(:cutoff)
    return if paychecks.empty?
    paychecks.first
  end
end