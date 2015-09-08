# == Schema Information
#
# Table name: directv_lead_dismissal_reasons
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  active     :boolean          default(TRUE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class DirecTVLeadDismissalReason < ActiveRecord::Base
  validates :name, presence: true
  validates :active, presence: true

  strip_attributes
end
