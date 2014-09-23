class Medium < ActiveRecord::Base
  belongs_to :mediable, polymorphic: true

  scope :visible, -> (person = nil)  {
    return self.none unless person
    return self.all if person.position and person.position.hq?
  }
end
