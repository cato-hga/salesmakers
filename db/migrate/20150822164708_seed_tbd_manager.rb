class SeedTbdManager < ActiveRecord::Migration
  def up
    Person.create email: 'tbd@salesmakersinc.com',
                  first_name: 'TBD',
                  last_name: 'Manager',
                  display_name: 'TBD Manager',
                  personal_email: 'tbd@salesmakersinc.com',
                  office_phone: '8005551212'
  end

  def down
    Person.where(email: 'tbd@salesmakersinc.com').destroy_all
  end
end
