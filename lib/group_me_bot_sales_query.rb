module GroupMeBotSalesQuery
  def determine_date_range
    @start_date = Date.today
    @end_date = Date.tomorrow
    mtd
    yesterday
    wtd
    weekend
    week
    month
  end

  def start_date
    @start_date
  end

  def end_date
    @end_date
  end

  protected

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

  def generate_chart(results)
    labels = []
    data = []
    for result in results do
      labels << result['name']
      data << result['count'].to_i
    end
    path = "sales_charts/#{SecureRandom.uuid}.png"
    chart = Gchart.new type: 'pie',
                       theme: :keynote,
                       labels: labels,
                       data: data,
                       size: '400x200',
                       filename: "public/#{path}"
    chart.file
    path
  end

  def start_date=(start_date)
    @start_date = start_date
  end

  def end_date=(end_date)
    @end_date = end_date
  end

  def has_keyword?(keyword)
    self.keywords.include?(keyword)
  end

  def mtd
    if has_keyword?('mtd')
      self.start_date = Date.today.beginning_of_month
      self.end_date = Date.tomorrow
    end
  end

  def yesterday
    if has_keyword?('yesterday')
      self.start_date = Date.yesterday
      self.end_date = Date.today
    end
  end

  def wtd
    if has_keyword?('wtd')
      self.start_date = Date.today.beginning_of_week
      self.end_date = Date.tomorrow
    end
  end

  def weekend
    if has_keyword?('weekend')
      self.start_date = Date.today.beginning_of_week + 4.days
      self.end_date = Date.today.beginning_of_week + 1.week
      if has_keyword?('last')
        self.start_date -= 1.week
        self.end_date -= 1.week
      end
    end
  end

  def week
    if has_keyword?('week')
      self.start_date = Date.today.beginning_of_week
      self.end_date = Date.today.beginning_of_week + 1.week
      if has_keyword?('last')
        self.start_date -= 1.week
        self.end_date -= 1.week
      end
    end
  end

  def month
    if has_keyword?('month')
      self.start_date = Date.today.beginning_of_month
      self.end_date = Date.today.end_of_month + 1.day
      puts self.end_date
      if has_keyword?('last')
        self.start_date -= 1.month
        self.end_date -= 1.month
      end
    end
  end
end