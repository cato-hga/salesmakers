class VonageGroupMeBotQuery
  protected
  def sales_from_and_joins
    from_and_joins 'sales'
  end

  def from_and_joins(type = 'sales')
    from_and_joins_string = self.send((type + '_every_from_and_join').to_sym)
    if has_keyword?('east')
      from_and_joins_string += self.send((type + '_parameter_where_clause').to_sym, 'region.name', 'Sprint Prepaid East Region')
    elsif has_keyword?('west')
      from_and_joins_string += self.send((type + '_parameter_where_clause').to_sym, 'region.name', 'Sprint Prepaid West Region')
    else
      from_and_joins_string += self.send((type + '_where_clause').to_sym)
    end
    from_and_joins_string
  end
end