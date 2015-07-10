require 'httparty'
require 'apis/authorized_api'
require 'apis/workmarket/workmarket_assignment_mapping'
require 'apis/workmarket/workmarket_attachment_mapping'
require 'apis/workmarket/workmarket_client_mapping'
require 'apis/workmarket/workmarket_field_mapping'
require 'apis/workmarket/workmarket_listed_assignment_mapping'
require 'apis/workmarket/workmarket_location_mapping'

class WorkmarketAPI
  include HTTParty
  include AuthorizedAPI
  #debug_output $stdout

  base_uri 'https://www.workmarket.com/api/v1'
  format :json

  def initialize
    @token = '0Ft3BIzVFhfFOP1dFXmq'
    @secret = 'n5P0ZNrjpIyuUw7KIBdNW7ENT0TmdAQevTQbk7Ow'
  end

  def authorization_hash
    return @authorization_hash if @authorization_hash
    response = self.class.post '/authorization/request', {
                                                           headers: {
                                                               'Content-Type' => 'application/x-www-form-urlencoded',
                                                               'Accept' => 'application/json'
                                                           },
                                                           body: {
                                                               'token' => @token,
                                                               'secret' => @secret
                                                           }
                                                       }
    @authorization_hash = { access_token: response.andand['response'].andand['access_token'] }
  end

  def get_completed_assignments
    statuses = ['complete', 'paymentPending', 'paid', 'refunded']
    assignments = []
    statuses.each { |s| assignments.concat get_assignments(s) }
    assignments
  end

  def get_completed_updated_assignments since_unix
    statuses = ['complete', 'paymentPending', 'paid', 'refunded']
    assignments = []
    statuses.each { |s| assignments.concat get_updated_assignments(s, since_unix) }
    assignments
  end

  def get_assignments status
    assignments = []
    start = 0
    loop do
      batch = get_assignment_list_batch status, start
      start += batch.length
      assignments.concat batch
      break if batch.length < 25
    end
    assignments
  end

  def get_updated_assignments status, since_unix
    assignments = []
    start = 0
    loop do
      batch = get_updated_assignment_list_batch status, since_unix, start
      start += batch.length
      assignments.concat batch
      break if batch.length < 25
    end
    assignments
  end

  def get_assignment_json id
    get_data doGet('/assignments/get', { id: id })
  end

  def get_assignment assignment_json
    return if assignment_json.blank?
    assignment = WorkmarketAssignment.new
    resource = assignment_json.andand['active_resource']
    check_in_outs = resource.andand['check_in_out']
    return if check_in_outs.nil? or check_in_outs.empty?
    assignment.attributes = {
        workmarket_assignment_num: assignment_json.andand['id'],
        json: assignment_json.to_json,
        title: assignment_json.andand['title'],
        worker_name: resource.andand['first_name'] + ' ' + resource.andand['last_name'],
        worker_first_name: resource.andand['first_name'],
        worker_last_name: resource.andand['last_name'],
        worker_email: resource.andand['email'],
        cost: assignment_json.andand['payment'].andand['total_cost'],
        started: Time.at(check_in_outs.first.andand['checked_in_on']),
        ended: Time.at(check_in_outs.last.andand['checked_out_on']),
        workmarket_location_num: assignment_json.andand['location'].andand['id'],
        project: Project.find_by(workmarket_project_num: assignment_json.andand['project'])
    }
    assignment
  end

  def get_attachments assignment_json
    return if assignment_json.nil?
    workmarket_assignment = WorkmarketAssignment.find_by workmarket_assignment_num: assignment_json.andand['id'] || return
    attachments = WorkmarketAttachmentMapping.extract_collection assignment_json.andand['attachments'].to_json, :read
    attachments.each { |a| a.workmarket_assignment = workmarket_assignment }
  end

  def get_attachment_base64 uuid
    return if uuid.nil?
    response = doGet '/assignments/attachments/get', { uuid: uuid }
    get_data(response).andand['attachment']
  end

  def get_custom_fields assignment_json
    return if assignment_json.nil?
    custom_fields_json = assignment_json.
        andand['custom_fields'].
        andand.
        first.
        andand['fields']
    return if custom_fields_json.nil? or custom_fields_json.empty?
    workmarket_assignment = WorkmarketAssignment.find_by workmarket_assignment_num: assignment_json.andand['id'] || return
    custom_fields = WorkmarketFieldMapping.extract_collection custom_fields_json.to_json, :read
    custom_fields.each { |f| f.workmarket_assignment = workmarket_assignment }
  end

  def get_clients
    response = doGet '/crm/clients/list'
    clients_json = get_data response
    return if clients_json.nil?
    WorkmarketClientMapping.extract_collection clients_json.to_json, :read
  end

  def get_locations client_id
    response = doGet '/crm/locations/list', { client_id: client_id }
    locations_json = get_data response
    return if locations_json.nil?
    WorkmarketLocationMapping.extract_collection locations_json.to_json, :read
  end

  private

  def get_assignment_list_batch status, start = 0
    response = doGet '/assignments/list', { status: status, start: start }
    WorkmarketListedAssignmentMapping.extract_collection get_data(response).andand['data'].to_json, :read
  end

  def get_updated_assignment_list_batch status, since_unix, start = 0
    response = doGet '/assignments/list_updated', { status: status, start: start, modified_since: since_unix }
    data = get_data(response).andand['data'].andand.to_json
    return [] unless data
    WorkmarketListedAssignmentMapping.extract_collection data, :read
  end

  def get_data(response)
    response.andand['response']
  end
end