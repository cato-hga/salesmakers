module DetermineSales

  private

  def determine_weeks
    start_date = @paycheck.commission_start
    end_date = @paycheck.commission_end
    @weeks = []
    current_start = start_date
    while current_start < end_date
      @weeks << [current_start, current_start + 6.days]
      current_start += 1.week
    end
    self
  end

  def split_sales_into_weeks
    return unless @weeks
    @week_sales = []
    for week in @weeks do
      @week_sales << @all_sales.where('sale_date >= ? AND sale_date <= ?',
                                      week[0], week[1])

    end
    self
  end

  def set_people_with_sales
    @people_with_sales = []
    for sale in @sales do
      @people_with_sales << sale.person if sale.person.commissionable?
    end
    @people_with_sales.uniq!
    self
  end

  def set_sale_count_for_each_person
    return unless @people_with_sales
    @person_sale_counts = []
    for person in @people_with_sales do
      @person_sale_counts << {
          person: person,
          sales: @sales.where(person: person).count
      }
    end
    self
  end
end