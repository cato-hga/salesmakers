module GroupMeBotSalesMessages
  def generate_messages(results)
    return [] unless results and results.count > 0
    char_count = 0
    result_strings = []
    result_string = ''
    total = 0
    message_count = 0
    for result in results do
      message_count += 1
      single_result = "[##{message_count.to_s}] #{result['name']}: #{result['count']}\n"
      total += result['count'].to_i
      if result_string.length + single_result.length > 390
        result_strings << result_string; result_string = single_result
      else
        result_string += single_result
      end
    end
    result_string += "\n***TOTAL: #{total}"
    result_strings << result_string
    result_strings
  end
end