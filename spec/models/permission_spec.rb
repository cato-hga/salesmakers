# == Schema Information
#
# Table name: permissions
#
#  id                  :integer          not null, primary key
#  key                 :string           not null
#  description         :string           not null
#  permission_group_id :integer          not null
#  created_at          :datetime
#  updated_at          :datetime
#

require 'rails_helper'

describe Permission do
end
