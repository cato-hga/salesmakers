module DetermineBrackets

  private

  def set_bracket_area_for_each_person
    return unless @person_sale_counts
    person_counts_with_area = []
    for person_sale_count in @person_sale_counts do
      bracket_area = get_bracket_area(person_sale_count[:person]) || next
      person_counts_with_area << person_sale_count.merge(bracket_area: bracket_area)
    end
    @person_sale_counts = person_counts_with_area
    self
  end

  def get_bracket_area(person)
    for person_area in person.person_areas do
      ancestors = person_area.area.ancestors
      for ancestor in ancestors.reverse do
        return ancestor unless ancestor.vonage_rep_sale_payout_brackets.empty?
      end
    end
    nil
  end

  def set_bracket_for_each_person
    return unless @person_sale_counts
    person_counts_with_bracket = []
    for person_sale_count in @person_sale_counts do
      bracket = get_bracket(person_sale_count) || next
      person_counts_with_bracket << person_sale_count.merge(bracket: bracket)
    end
    @person_sale_counts = person_counts_with_bracket
    self
  end

  def get_bracket(person_sale_count)
    area = person_sale_count[:bracket_area] || return
    count = person_sale_count[:sales]
    brackets = area.
        vonage_rep_sale_payout_brackets.where('sales_minimum <= ? AND sales_maximum >= ?',
                                              count, count)
    return if brackets.empty?
    brackets.first
  end
end