require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe Client, :type => :model do

  it { should ensure_length_of(:name).is_at_least(2) }

  it { should have_many(:projects) }

  describe 'individual client booleans' do
    let(:vonage_client) { create :client, name: 'Vonage' }
    let(:sprint_client) { create :client, name: 'Sprint' }
    let(:project) { create :project }
    let(:area) { create :area, project: project }
    let(:person) { create :person }
    let!(:person_area) {
      create :person_area, person: person, area: area
    }

    it 'detects a Vonage employee' do
      project.update client: vonage_client
      expect(Client.vonage?(person)).to be_truthy
      expect(Client.sprint?(person)).to be_falsey
    end

    it 'detects a Sprint employee' do
      project.update client: sprint_client
      expect(Client.sprint?(person)).to be_truthy
      expect(Client.vonage?(person)).to be_falsey
    end
  end
end
