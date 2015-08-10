# == Schema Information
#
# Table name: unmatched_candidates
#
#  id         :integer          not null, primary key
#  last_name  :string           not null
#  first_name :string           not null
#  email      :string           not null
#  score      :float            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UnmatchedCandidate < ActiveRecord::Base
end
