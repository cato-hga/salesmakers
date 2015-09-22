class AssetShiftHoursTotaling

  def initialize(duration, automated = false)
    return if RunningProcess.running? self
    begin
      RunningProcess.running! self
      @duration = duration
      generate_totals automated
    ensure
      RunningProcess.shutdown! self
    end
  end

  def generate_totals automated = false
    shifts = Shift.where('date >= ?', DateTime.now - @duration)
    prepaid = Project.find_by name: 'Sprint Prepaid'
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
    SlackJobNotifier.ping "[AssetShiftHoursTotaling] Finished asset hours total generation for #{people.count.to_s} people."
    ProcessLog.create process_class: "AssetShiftHoursTotaling",
                      records_processed: people.count,
                      notes: 'generate_totals' if automated
  end

  def self.generate_mailer automated = false
    people_waiting_on_assets = Person.where('passed_asset_hours_requirement = ? and (vonage_tablet_approval_status = ? or sprint_prepaid_asset_approval_status = ?)', true, 0, 0).uniq.flatten
    prepaid = Project.find_by name: 'Sprint Prepaid'
    vonretail = Project.find_by name: 'Vonage'
    vonevents = Project.find_by name: 'Vonage Events'
    projects = [prepaid, vonretail, vonevents]
    supervisor_for_assets = []
    for person in people_waiting_on_assets
      next unless person.person_areas.any?
      supervisor_for_assets << person.get_supervisors if projects.include? person.person_areas.first.area.project
    end
    supervisor_for_assets = supervisor_for_assets.uniq.flatten
    for supervisor in supervisor_for_assets do
      AssetsMailer.asset_approval_mailer(supervisor).deliver_later
    end
    SlackJobNotifier.ping "[AssetShiftHoursTotaling] Sent asset approval emails for #{people_waiting_on_assets.count.to_s} people."
    ProcessLog.create process_class: "AssetShiftHoursTotaling",
                      records_processed: people_waiting_on_assets.count,
                      notes: 'generate_mailer' if automated
  end
end