require 'rails_helper'

describe HistoricalRecording do
  let!(:supervisor) { create :person }
  let(:person) { create :person, supervisor: supervisor }
  let!(:location_area) { create :location_area }
  let!(:person_area) { create :person_area, area: location_area.area, person: person }
  let!(:location_client_area) { create :location_client_area, location: location_area.location }
  let!(:person_client_area) { create :person_client_area, person: person, client_area: location_client_area.client_area }

  let(:recorder) { described_class.new }

  before { recorder.record }

  it 'records all necessary records' do
    expect(HistoricalArea.count).to eq(1)
    expect(HistoricalLocation.count).to eq(1)
    expect(HistoricalPerson.count).to eq(2)
    expect(HistoricalPerson.where("supervisor_id IS NOT NULL").count).to eq(1)
    expect(HistoricalPersonArea.count).to eq(1)
    expect(HistoricalLocationArea.count).to eq(1)
    expect(HistoricalClientArea.count).to eq(1)
    expect(HistoricalLocationClientArea.count).to eq(1)
    expect(HistoricalPersonClientArea.count).to eq(1)
  end
end