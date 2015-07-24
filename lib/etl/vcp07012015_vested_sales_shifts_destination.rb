class VCP07012015VestedSalesShiftsDestination
  def write vested_sales_shift
    saved_vested_sales_shift = VCP07012015VestedSalesShift.new vested_sales_shift
    return unless saved_vested_sales_shift.valid?
    saved_vested_sales_shift.save
  end

  def close; end
end