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
require 'shoulda/matchers'

RSpec.describe Position, :type => :model do

  it { should ensure_length_of(:name).is_at_least(4) }
  it { should validate_presence_of(:department) }
  it { should have_and_belong_to_many(:permissions) }

end
