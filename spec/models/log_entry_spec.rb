# == Schema Information
#
# Table name: log_entries
#
#  id                 :integer          not null, primary key
#  person_id          :integer          not null
#  action             :string           not null
#  comment            :text
#  trackable_id       :integer          not null
#  trackable_type     :string           not null
#  referenceable_id   :integer
#  referenceable_type :string
#  created_at         :datetime
#  updated_at         :datetime
#

require 'rails_helper'

describe LogEntry do
end
