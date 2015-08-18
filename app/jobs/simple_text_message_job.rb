require 'apis/gateway'

class TextMessageToPersonJob < ActiveJob::Base
  queue_as :default

  def perform phone, message
    gateway = Gateway.new
    gateway.send_text phone, message
  end
end