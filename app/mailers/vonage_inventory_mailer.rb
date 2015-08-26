class VonageInventoryMailer < ApplicationMailer
  default from: 'development@retaildoneright.com'


  def inventory_receiving_mailer(person, macs )
    @person = person
    @macs = macs
    @vonage_devices = VonageDevice.where id: macs
    Rails.logger.debug @vonage_devices.inspect

    mail to: @person.email,
         subject: 'Vonage Inventory Received'

  end
end
