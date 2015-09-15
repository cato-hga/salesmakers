class SprintSalesDestination
  def write sale
    return if not sale[:connect_sprint_sale_id] or
        SprintSale.find_by(connect_sprint_sale_id: sale[:connect_sprint_sale_id])
    saved_sale = SprintSale.new sale
    saved_sale.import = true
    saved_sale.save
    puts saved_sale.errors.full_messages.join(', ') if saved_sale.errors.any?
  end

  def close; end
end