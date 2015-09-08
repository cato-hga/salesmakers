# == Schema Information
#
# Table name: clients
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'
require 'shoulda/matchers'

describe Client do

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
