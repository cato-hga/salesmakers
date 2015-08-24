# == Schema Information
#
# Table name: person_punches
#
#  id         :integer          not null, primary key
#  identifier :string           not null
#  punch_time :datetime         not null
#  in_or_out  :integer          not null
#  person_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

describe PersonPunch do
end
