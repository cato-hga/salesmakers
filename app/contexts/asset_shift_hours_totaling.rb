class AssetShiftHoursTotaling

  def initialize(duration)
    @duration = duration
    generate_totals
  end

  def generate_totals
    shifts = Shift.where('date >= ?', DateTime.now - @duration)
    prepaid = Project.find_by name: 'Sprint Retail'
    people = []
    for shift in shifts do
      people << shift.person unless shift.person.skip_for_assets?
    end
    for person in people do
      person_hours = Shift.where(person: person).sum(:hours).to_i
      if person_hours > 40 or (person.project and person.project == prepaid)
        person.update passed_asset_hours_requirement: true
      end
    end
  end
end