# == Schema Information
#
# Table name: communication_log_entries
#
#  id            :integer          not null, primary key
#  loggable_id   :integer          not null
#  loggable_type :string           not null
#  created_at    :datetime
#  updated_at    :datetime
#  person_id     :integer          not null
#

class CommunicationLogEntry < ActiveRecord::Base
  validates :loggable, presence: true
  validates :person, presence: true

  belongs_to :loggable, polymorphic: true
  belongs_to :person

  default_scope { order(created_at: :desc) }
end
