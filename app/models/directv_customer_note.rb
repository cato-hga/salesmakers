# == Schema Information
#
# Table name: directv_customer_notes
#
#  id                  :integer          not null, primary key
#  directv_customer_id :integer          not null
#  created_at          :datetime         not null
#  note                :text             not null
#  person_id           :integer          not null
#  updated_at          :datetime         not null
#

class DirecTVCustomerNote < ActiveRecord::Base
  validates :person, presence: true
  validates :directv_customer, presence: true
  validates :note, length: { minimum: 5 }

  belongs_to :directv_customer
  belongs_to :person
end
