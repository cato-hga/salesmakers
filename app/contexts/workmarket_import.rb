require 'apis/workmarket_api'

class WorkmarketImport
  def initialize
    @api = WorkmarketAPI.new
  end

  def execute
    start_location_import
    start_assignment_import
    self
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
    filter_to_new_assignments
    import_assignments
    self
  end

  def set_completed_assignments
    @listed_assignments = @api.get_completed_assignments
    self
  end

  def filter_to_new_assignments
    new_assignments = []
    @listed_assignments.each do |assignment|
      saved_assignment = WorkmarketAssignment.find_by workmarket_assignment_num: assignment.workmarket_assignment_num
      new_assignments << assignment unless saved_assignment
    end
    @listed_assignments = new_assignments
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
      import_attachments json
      import_fields json
    end
  end

  def import_attachments json
    attachments = @api.get_attachments json
    return if attachments.nil?
    attachments.each { |a| a.save }
  end

  def import_fields json
    fields = @api.get_custom_fields json
    return if fields.nil?
    fields.each { |f| f.save }
  end
end