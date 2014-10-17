class Publication < ActiveRecord::Base
  belongs_to :publishable, polymorphic: true

  def self.publish(publishable, person)
    return unless publishable and person
    self.find_or_create_by publishable: publishable
  end

  def person
    return unless publishable and publishable.person
    publishable.person
  end
end
