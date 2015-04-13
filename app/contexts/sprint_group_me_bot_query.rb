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

  def from_and_joins
    from_and_joins_string = every_from_and_join
    if has_keyword?('east')
      from_and_joins_string += parameter_where_clause('region.name', 'Sprint Prepaid East Region')
    elsif has_keyword?('west')
      from_and_joins_string += parameter_where_clause('region.name', 'Sprint Prepaid West Region')
    elsif has_director_keyword?
      from_and_joins_string += parameter_where_clause('r.description', director_name)
    else
      from_and_joins_string += self.where_clause
    end
    from_and_joins_string
  end
end