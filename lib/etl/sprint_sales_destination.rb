class SprintSalesDestination
  def write sale
    puts sale.inspect
    return if not sale[:connect_sprint_sale_id] or
        SprintSale.find_by(connect_sprint_sale_id: sale[:connect_sprint_sale_id])
    saved_sale = SprintSale.create sale
    puts saved_sale.errors.full_messages.join(', ') if saved_sale.errors.any?
  end

  def close; end
end