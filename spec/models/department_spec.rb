# == Schema Information
#
# Table name: departments
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  corporate  :boolean          not null
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'
require 'shoulda/matchers'

describe Department do
  #TODO: Test default_scope
end
