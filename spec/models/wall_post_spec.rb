require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe WallPost, :type => :model do

  it { should belong_to :wall }
  it { should belong_to :person }
  it { should belong_to :publication }

  #TODO: Test create_from_publication
end
