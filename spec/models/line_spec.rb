require 'rails_helper'

RSpec.describe Line, :type => :model do

  it { should ensure_length_of(:identifier).is_at_least(10) }
  it { should validate_presence_of(:contract_end_date) }
  it { should validate_presence_of(:technology_service_provider) }

end