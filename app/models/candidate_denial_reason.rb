# == Schema Information
#
# Table name: candidate_denial_reasons
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  active     :boolean          default(TRUE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CandidateDenialReason < ActiveRecord::Base

  validates :name, presence: true
  validates :active, presence: true

  has_many :log_entries, as: :referenceable, dependent: :destroy

  strip_attributes
end
