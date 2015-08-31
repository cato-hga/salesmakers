# == Schema Information
#
# Table name: job_offer_details
#
#  id                     :integer          not null, primary key
#  candidate_id           :integer          not null
#  sent                   :datetime         not null
#  completed              :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  envelope_guid          :string
#  completed_by_candidate :datetime
#  completed_by_advocate  :datetime
#

class JobOfferDetail < ActiveRecord::Base
  validates :candidate_id, presence: true
  validates :sent, presence: true

  belongs_to :candidate
  has_many :log_entries, as: :trackable, dependent: :destroy
end
