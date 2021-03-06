# == Schema Information
#
# Table name: ahoy_events
#
#  id         :uuid             not null, primary key
#  visit_id   :uuid
#  person_id  :integer
#  name       :string
#  properties :json
#  time       :datetime
#

module Ahoy
  class Event < ActiveRecord::Base
    self.table_name = "ahoy_events"

    belongs_to :visit
    belongs_to :person
  end
end
