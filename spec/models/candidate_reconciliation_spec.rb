# == Schema Information
#
# Table name: candidate_reconciliations
#
#  id           :integer          not null, primary key
#  candidate_id :integer          not null
#  status       :integer          default(0), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

describe CandidateReconciliation do
end
