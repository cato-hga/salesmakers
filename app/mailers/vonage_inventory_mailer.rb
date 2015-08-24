class VonageInventoryMailer < ApplicationMailer
  default from: 'development@retaildoneright.com'


  def inventory_receiving_mailer(person, macs)
    @person = person
    @macs = macs
    mail to: @person.email,
         subject: 'Vonage Inventory Received'
  end

end
