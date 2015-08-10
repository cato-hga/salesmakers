module GroupMeBotSalesMessages
  def sales_generate_messages(results)
    return [] unless results and results.count > 0
    char_count = 0
    sales_strings = []
    sales_string = ''
    total = 0
    message_count = 0
    for result in results do
      message_count += 1
      sales_result = "[##{message_count.to_s}] #{result['name']}: #{result['count']}\n"
      total += result['count'].to_i
      if sales_string.length + sales_result.length > 390
        sales_strings << sales_string; sales_string = sales_result
      else
        sales_string += sales_result
      end
    end
    sales_string += "\n***TOTAL: #{total}"
    sales_strings << sales_string
    sales_strings
  end
end