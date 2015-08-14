# == Schema Information
#
# Table name: client_areas
#
#  id                  :integer          not null, primary key
#  name                :string           not null
#  client_area_type_id :integer          not null
#  ancestry            :string
#  created_at          :datetime
#  updated_at          :datetime
#  project_id          :integer          not null
#

require 'rails_helper'
require 'shoulda/matchers'

describe ClientArea do

  it ' project_roots scope should return project_roots' do
    proj = Project.first
    expect(ClientArea.project_roots(proj)).not_to be_nil
  end

end
