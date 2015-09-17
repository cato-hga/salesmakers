class VonageComp07012015ShiftsSource
  def initialize start_date_attribute, end_date_attribute
    @period = get_commission_period
    vonage_retail = Project.find_by name: 'Vonage'
    vonage_events = Project.find_by name: 'Vonage Events'
    people = vonage_retail.active_people
    people = people.concat(vonage_events.active_people).flatten if vonage_events
    if @period and @period[start_date_attribute] and @period[end_date_attribute] and !people.empty?
      @shifts = Shift.where "date >= ? AND date <= ? AND person_id IN (#{people.map(&:id).join(',')})",
                            @period[start_date_attribute],
                            @period[end_date_attribute]
    else
      @shifts = []
    end
  end

  def each
    @shifts.each do |shift|
      yield shift.attributes.merge({ vonage_commission_period07012015_id: @period.id })
    end
  end

  private

  def get_commission_period
    periods = VonageCommissionPeriod07012015.where("cutoff > ?", DateTime.now).order(:cutoff)
    return nil if periods.empty?
    periods.first
  end
end