class SeedSMSMemberChanges < ActiveRecord::Migration
  def self.up
    position = Position.find_by name: 'SalesMakers Support Member'
    return unless position
    emails = [
        'rpitman@retaildoneright.com',
        'jparlette@salesmakersinc.com',
        'apolancodelahoz@retaildoneright.com',
        'anthwilliams@retaildoneright.com',
        'tbeverly@retaildoneright.com',
        'rdixon@retaildoneright.com',
        'mgiordano@rbd-spr.com',
        'severetts@rbd-von.com'
    ]
    for email in emails do
      person = Person.find_by email: email
      next unless person
      person.update position: position
    end
  end
end
