require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe PersonClientArea, :type => :model do

  it { should validate_presence_of(:person) }
  it { should validate_presence_of(:client_area) }

  it { should belong_to :person }
  it { should belong_to :client_area }
end
