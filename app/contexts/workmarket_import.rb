require 'apis/workmarket_api'

class WorkmarketImport
  def initialize
    @api = WorkmarketAPI.new
    @count = 0
  end

  def execute automated = false
    return if RunningProcess.running? self
    begin
      RunningProcess.running! self
      start_location_import
      start_assignment_import
      SlackJobNotifier.ping "[WorkmarketImport] Imported #{@count.to_s} Workmarket assignments." if @count > 0
      ProcessLog.create process_class: "WorkmarketImport", records_processed: @count if automated
      self
    ensure
      RunningProcess.shutdown! self
    end
  end

  def start_location_import
    set_locations
    return if @locations.nil?
    filter_to_new_locations
    import_locations
    self
  end

  def set_locations
    @locations = []
    clients = @api.get_clients
    clients.each { |c| @locations.concat @api.get_locations c.workmarket_client_num }
    self
  end

  def filter_to_new_locations
    new_locations = []
    @locations.each do |location|
      saved_location = WorkmarketLocation.find_by workmarket_location_num: location.workmarket_location_num
      new_locations << location unless saved_location
    end
    @locations = new_locations
    self
  end

  def import_locations
    @locations.each { |l| l.save }
  end

  def start_assignment_import
    set_completed_assignments
    return if @listed_assignments.nil?
    delete_previously_stored_assignments
    import_assignments
    self
  end

  def set_completed_assignments
    since_result = ActiveRecord::Base.connection.execute 'SELECT max(created_at) FROM workmarket_assignments'
    since = since_result.andand[0].andand['max'].andand.to_datetime.andand.to_i
    unless since
      since = Rails.env.test? ? DateTime.now.beginning_of_week - 1.day : DateTime.new(2015, 4, 21, 13, 30, 12).to_i
    end
    @listed_assignments = @api.get_completed_updated_assignments since
    self
  end

  def delete_previously_stored_assignments
    @listed_assignments.each do |assignment|
      saved_assignment = WorkmarketAssignment.find_by workmarket_assignment_num: assignment.workmarket_assignment_num
      saved_assignment ? saved_assignment.destroy : nil
    end
    self
  end

  def import_assignments
    @listed_assignments.each do |listed_assignment|
      json = @api.get_assignment_json listed_assignment.workmarket_assignment_num
      next if json.nil?
      import_assignment json
    end
  end

  def import_assignment json
    assignment = @api.get_assignment json
    return if assignment.nil?
    if assignment.save
      @count += 1
      import_attachments json
      import_fields json
    end
  end

  def import_attachments json
    attachments = @api.get_attachments json
    return if attachments.nil?
    attachments.each do |a|
      a.save
      FileUtils.mkdir_p 'public/uploads/' + a.guid
      File.open("public/uploads/#{a.guid}/#{a.filename}", 'wb') do |f|
        base64 = get_attachment_base64(a.guid)
        if base64
          f.write(Base64.decode64(base64))
        else
          sleep 1
          base64 = get_attachment_base64(a.guid)
          if base64
            f.write(Base64.decode64(base64))
          else
            f.write('')
          end
        end
      end
    end
  end

  def get_attachment_base64 guid
    return if guid.nil?
    @api.get_attachment_base64 guid
  end

  def import_fields json
    fields = @api.get_custom_fields json
    return if fields.nil?
    fields.each { |f| f.save }
  end
end