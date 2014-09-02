module PersonVisibility
  extend ActiveSupport::Concern

  included do
    scope :visible, -> (person = nil ){
      return self.none unless person
      people = Person.visible(person)
      self.where("person_id IN (#{people.map(&:id).join(',')})")
    }
  end
end