module DateAndTimeHelperExtension
  def short_date(date)
    return '' unless date
    date.strftime '%m/%d/%Y'
  end

  def med_date(date)
    date.strftime '%a, %b %-d, %Y'
  end

  def long_date(date)
    date.strftime '%A, %B %-d, %Y'
  end

  def friendly_datetime(datetime)
    if datetime.strftime('%m/%d/%Y') == Time.zone.now.strftime('%m/%d/%Y')
      datetime.strftime('%l:%M%P %Z')
    elsif datetime.year == Time.zone.now.year
      datetime.strftime('%m/%d %l:%M%P %Z')
    else
      datetime.strftime('%m/%d/%Y %l:%M%P %Z')
    end
  end

  def full_datetime(datetime)
    datetime.strftime('%m/%d/%Y %l:%M%P %Z')
  end
end