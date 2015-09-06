class RosterVerificationNotificationJob < ActiveJob::Base
  queue_as :default

  def perform automated = false
    return if RunningProcess.running? self
    begin
      RunningProcess.running! self
      areas = Area.where active: true
      managers = []
      for area in areas do
        puts area.name
        next if area.has_children?
        person_areas = area.person_areas.where manages: true
        if person_areas.empty?
          parent_area = area.parent
          until parent_area.nil? || !person_areas.empty?
            person_areas = parent_area.person_areas.where manages: true
            parent_area = parent_area.parent
          end
        end
        person_areas.each do |person_area|
          managers << person_area.person
          puts person_area.person.display_name
        end
        puts '-----------------------'
      end
      puts managers.uniq.count
      for manager in managers.uniq do
        RosterVerificationMailer.send_notification_and_link(manager).deliver_later
      end
      ProcessLog.create process_class: "RosterVerificationNotificationJob", records_processed: managers.uniq.count if automated
    end
  ensure
    RunningProcess.shutdown! self
  end
end