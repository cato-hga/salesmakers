class VCP07012015VestedSalesSalesDestination
  def write vested_sales_sale
    saved_vested_sales_sale = VCP07012015VestedSalesSale.new vested_sales_sale
    return unless saved_vested_sales_sale.valid?
    saved_vested_sales_sale.save
  end

  def close; end
end