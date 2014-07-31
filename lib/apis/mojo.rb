class Mojo
  include HTTParty
  base_uri 'support.rbdconnect.com/api'
  format :json

  require 'open-uri'

  def initialize
    @access_key = 'be673c9221173ec77d4b8bcd33909d2331eccf6e'
  end

  def get_ticket(ticket_id)
    ticket_id = ticket_id.to_s
    ticket = doGet('/tickets/' + ticket_id + '.json')
    return nil unless ticket.success? and ticket['ticket']
    ticket['ticket']
  end

  def creator_open_tickets(email)
    query = 'created_by_email:("' + email + '") AND status_id:(<50)'
    tickets = doGet('/tickets/search/', { query: query, sf: 'updated_on', r: 1 })
    tickets
  end

  def creator_all_tickets(email, max = 20)
    query = 'created_by_email:("' + email + '")'
    tickets = doGet('/tickets/search/', { query: query, per_page: max, sf: 'updated_on', r: 1 })
    max_index = max-1
    tickets[ 0..max_index ]
  end

  def assignee_open_tickets(email)
    query = 'assignee_email:("' + email + '") AND status_id:(<50)'
    tickets = doGet('/tickets/search/', { query: query, sf: 'updated_on', r: 1  })
    tickets
  end

  def doGet(path, query = nil)
    query_hash = { access_key: @access_key }
    query_hash = query_hash.merge query if query
    self.class.get path, { query: query_hash, headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json'} }
  end

end