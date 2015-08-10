# == Schema Information
#
# Table name: comcast_lead_dismissal_reasons
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  active     :boolean          default(TRUE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ComcastLeadDismissalReason < ActiveRecord::Base

  validates :name, presence: true
  validates :active, presence: true

end
