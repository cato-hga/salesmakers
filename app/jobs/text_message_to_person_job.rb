require 'apis/gateway'

class TextMessageToPersonJob < ActiveJob::Base
  queue_as :default

  def perform person, message, sender
    gateway = Gateway.new
    gateway.send_text_to_person person, message, sender
  end
end