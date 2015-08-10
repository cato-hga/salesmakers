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
require 'shoulda/matchers'

RSpec.describe Permission, :type => :model do


  it { should ensure_length_of(:key).is_at_least(5) }
  it { should ensure_length_of(:description).is_at_least(10) }
  it { should validate_presence_of(:permission_group) }

  it { should belong_to :permission_group }
  it { should have_and_belong_to_many :positions }

end
