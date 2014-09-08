require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe Profile, :type => :model do

  it { should validate_presence_of(:person) }

  it { should belong_to :person }
  it { should have_many :profile_educations }
  it { should have_many :profile_experiences }
  it { should have_many :profile_skills }

  #TODO: Test :set_defaults
  #TODO: Test :nullify_values
end
