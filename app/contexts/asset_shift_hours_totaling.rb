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
      if person_hours > 40 or (person.person_areas.first.area.project == prepaid) #Just doing the first person area, since we don't have multiple person areas just yet.
        person.update passed_asset_hours_requirement: true
      end
    end
  end

  def generate_mailer
    # people_waiting_on_assets = Person.where('passed_asset_hours_requirement = true and (vonage_table_approval_status = 0 or sprint_prepaid_asset_approval_status = 0')
    # prepaid = Project.find_by name: 'Sprint Retail'
    # vonretail = Project.find_by name: 'Vonage Retail'
    # vonevents = Project.find_by name: 'Vonage Events'
    # projects = [prepaid, vonretail, vonevents]
    # correct_people_for_assets = []
    # supervisors_for_assets = []
    # for person in people_waiting_on_assets
    #   supervisor_for_assets << person.get_supervisors if projects.include? person.person_areas.first.area.project
    # end
    # supervisor_for_assets = supervisor_for_assets.uniq.flatten
    # for supervisor in supervisor_for_assets do
    #   AssetMailer.approval_mailer(supervisor)
    # end
  end
end