class VCP07012015HPSSalesDestination
  def write hps_sale
    saved_hps_sale = VCP07012015HPSSale.new hps_sale
    return unless saved_hps_sale.valid?
    saved_hps_sale.save
  end

  def close; end
end