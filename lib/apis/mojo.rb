class Mojo
  include HTTParty
  base_uri 'support.rbdconnect.com/api'
  format :json

  def initialize
    @access_key = 'be673c9221173ec77d4b8bcd33909d2331eccf6e'
  end

  def get_ticket(ticket_id)
    ticket_id = ticket_id.to_s
    ticket = doGet('/tickets/' + ticket_id + '.json')
    return nil unless ticket.success? and ticket['ticket']
    ticket['ticket']
  end

  def doGet(path)
    self.class.get path, { query: { access_key: @access_key } }
  end
end