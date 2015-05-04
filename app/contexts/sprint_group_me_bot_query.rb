class SprintGroupMeBotQuery
  protected

  def director_name
    directors.map { |d| has_keyword?(d) ? d : nil }.compact.first
  end

  def directors
    ['bland', 'moulison', 'miller', 'willison']
  end

  def has_director_keyword?
    directors.each { |d| return true if has_keyword?(d) }
    false
  end

  def sales_from_and_joins
    from_and_joins 'sales'
  end

  def hpa_from_and_joins
    from_and_joins 'hpa'
  end

  def from_and_joins(type = 'sales')
    from_and_joins_string = self.send((type + '_every_from_and_join').to_sym)
    if has_keyword?('east')
      from_and_joins_string += self.send((type + '_parameter_where_clause').to_sym, 'region.name', 'Sprint Prepaid East Region')
    elsif has_keyword?('west')
      from_and_joins_string += self.send((type + '_parameter_where_clause').to_sym, 'region.name', 'Sprint Prepaid West Region')
    elsif has_director_keyword?
      from_and_joins_string += self.send((type + '_parameter_where_clause').to_sym, 'r.description', director_name)
    else
      from_and_joins_string += self.send((type + '_where_clause').to_sym)
    end
    from_and_joins_string
  end
end