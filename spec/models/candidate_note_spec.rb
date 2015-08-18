# == Schema Information
#
# Table name: candidate_notes
#
#  id           :integer          not null, primary key
#  candidate_id :integer          not null
#  person_id    :integer          not null
#  note         :text             not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

describe CandidateNote do
end
