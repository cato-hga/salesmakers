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
      if person_hours > 40 or (person.person_areas.any? and (person.person_areas.first.area.project == prepaid and person_hours > 30)) #Just doing the first person area, since we don't have multiple person areas just yet.
        person.update passed_asset_hours_requirement: true
      end
    end
  end

  def self.generate_mailer
    people_waiting_on_assets = Person.where('passed_asset_hours_requirement = ? and (vonage_tablet_approval_status = ? or sprint_prepaid_asset_approval_status = ?)', true, 0, 0).uniq.flatten
    prepaid = Project.find_by name: 'Sprint Retail'
    vonretail = Project.find_by name: 'Vonage Retail'
    vonevents = Project.find_by name: 'Vonage Events'
    projects = [prepaid, vonretail, vonevents]
    supervisor_for_assets = []
    for person in people_waiting_on_assets
      supervisor_for_assets << person.get_supervisors if projects.include? person.person_areas.first.area.project
    end
    supervisor_for_assets = supervisor_for_assets.uniq.flatten
    for supervisor in supervisor_for_assets do
      AssetsMailer.asset_approval_mailer(supervisor).deliver_later
    end
  end
end