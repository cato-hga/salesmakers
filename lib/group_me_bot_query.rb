module GroupMeBotQuery
  def determine_date_range
    @start_date = Time.now.utc.apply_pacific_offset.beginning_of_day.to_date
    @end_date = Time.now.utc.apply_pacific_offset.beginning_of_day.to_date + 1.day
    mtd
    yesterday
    wtd
    weekend
    week
    month
  end

  def check_environment
    if Rails.env.production? or Rails.env == 'staging'
      @chart_url = "#{Rails.application.routes.url_helpers.root_url}#{generate_pie_chart(@results)}"
    else
      @chart_url = "http://localhost:3000/#{generate_pie_chart(@results)}"
    end
  end

  def separate_string
    self.keywords = Array.new
    self.query_string = Array.new
    for word in @callback.text.split do
      word.strip!; word.gsub!(/[^A-Za-z0-9 ]/, '')
      if keyword_list.include?(word)
        self.keywords << word
      else
        self.query_string << word
      end
    end
    self.query_string = self.query_string.join(' ').strip
  end

  def start_date
    @start_date
  end

  def end_date
    @end_date
  end

  protected

  def generate_pie_chart(results)
    return unless results
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
      period_to_date 'month'
    end
  end

  def yesterday
    if has_keyword?('yesterday')
      self.start_date = Time.now.utc.apply_pacific_offset.to_date - 1.day
      self.end_date = Time.now.utc.apply_pacific_offset.to_date
    end
  end

  def wtd
    if has_keyword?('wtd')
      period_to_date 'week'
    end
  end

  def period_to_date(beginning_of_period)
    self.start_date = Time.now.utc.apply_pacific_offset.send("beginning_of_#{beginning_of_period}".to_sym).to_date
    self.end_date = Time.now.utc.apply_pacific_offset.to_date + 1.day
  end

  def weekend
    subtract = has_keyword?('last') ? 1.week : 0
    if has_keyword?('weekend')
      self.start_date = Time.now.utc.apply_pacific_offset.beginning_of_week.to_date + 4.days - subtract
      self.end_date = Time.now.utc.apply_pacific_offset.beginning_of_week.to_date + 1.week - subtract
    end
  end
end

def week
  if has_keyword?('week')
    self.start_date = Time.now.utc.apply_pacific_offset.beginning_of_week.to_date
    self.end_date = Time.now.utc.apply_pacific_offset.beginning_of_week.to_date + 1.week
    if has_keyword?('last')
      self.start_date -= 1.week
      self.end_date -= 1.week
    end
  end
end

def month
  if has_keyword?('month')
    self.start_date = Time.now.apply_pacific_offset.beginning_of_month.to_date
    self.end_date = Time.now.apply_pacific_offset.end_of_month.to_date + 1.day
    if has_keyword?('last')
      self.start_date -= 1.month
      self.end_date -= 1.month
    end
  end
end