# == Schema Information
#
# Table name: comcast_customer_notes
#
#  id                  :integer          not null, primary key
#  comcast_customer_id :integer          not null
#  person_id           :integer          not null
#  note                :text             not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class ComcastCustomerNote < ActiveRecord::Base
  validates :person, presence: true
  validates :comcast_customer, presence: true
  validates :note, length: { minimum: 5 }

  belongs_to :comcast_customer
  belongs_to :person
end
