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

require 'rails_helper'

describe ComcastCustomerNote do
end
