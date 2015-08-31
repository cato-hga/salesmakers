# == Schema Information
#
# Table name: candidate_sources
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  active     :boolean          default(TRUE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CandidateSource < ActiveRecord::Base
  validates :name, presence: true

  default_scope { order :name }

  strip_attributes
end
