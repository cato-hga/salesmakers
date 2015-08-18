# == Schema Information
#
# Table name: positions
#
#  id                       :integer          not null, primary key
#  name                     :string           not null
#  leadership               :boolean          not null
#  all_field_visibility     :boolean          not null
#  all_corporate_visibility :boolean          not null
#  department_id            :integer          not null
#  created_at               :datetime
#  updated_at               :datetime
#  field                    :boolean
#  hq                       :boolean
#  twilio_number            :string
#

require 'rails_helper'

describe Position do
end
