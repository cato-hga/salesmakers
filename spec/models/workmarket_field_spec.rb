# == Schema Information
#
# Table name: workmarket_fields
#
#  id                       :integer          not null, primary key
#  workmarket_assignment_id :integer          not null
#  name                     :string           not null
#  value                    :string           not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

require 'rails_helper'

describe WorkmarketField do
end
