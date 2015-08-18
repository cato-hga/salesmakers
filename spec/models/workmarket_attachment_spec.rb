# == Schema Information
#
# Table name: workmarket_attachments
#
#  id                       :integer          not null, primary key
#  workmarket_assignment_id :integer          not null
#  filename                 :string           not null
#  url                      :string           not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  guid                     :string           not null
#

require 'rails_helper'

describe WorkmarketAttachment do
end
