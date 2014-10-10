require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe Project, :type => :model do

  it { should ensure_length_of(:name).is_at_least(4) }
  it { should validate_presence_of(:client) }

  it { should belong_to :client }
  it { should have_many :area_types }
  it { should have_many :areas }

end