require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe UploadedImage, :type => :model do
  it { should have_one :medium }
  it { should belong_to :person }
end
