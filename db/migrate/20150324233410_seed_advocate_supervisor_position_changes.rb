class SeedAdvocateSupervisorPositionChanges < ActiveRecord::Migration
  def self.up
    position = Position.find_by name: 'Advocate Supervisor'
    return unless position
    emails = [
        'rmaley@hireretailpros.com',
        'mbailey@hireretailpros.com',
        'abode@hireretailpros.com',
        'kkarcher@hireretailpros.com'
    ]
    for email in emails do
      person = Person.find_by email: email
      next unless person
      person.update position: position
    end
  end
end
