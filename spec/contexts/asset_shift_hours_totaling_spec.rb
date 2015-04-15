require 'asset_shift_hours_totaling'

describe AssetShiftHoursTotaling do

  let(:duration) { 24.hours }

  describe '.initialize' do
    it 'sets the previous duration to search though for people to total' do
      expect(AssetShiftHoursTotaling).to receive(:new).and_return(24.hours)
      AssetShiftHoursTotaling.new(duration)
    end
  end

  describe '.generate_totals' do
    let(:non_vonage_person) { create :person, display_name: 'Non Vonage', passed_asset_hours_requirement: false, vonage_tablet_approval_status: 0 }
    let!(:non_vonage_person_area) { create :person_area, area: non_vonage_area, person: non_vonage_person }
    let(:non_vonage_area) { create :area, project: non_vonage_project }
    let(:non_vonage_project) { create :project, name: 'Not Correct' }
    let!(:non_vonage_shift) { create :shift, person: non_vonage_person, date: Date.today - 3.hours, hours: 41 }

    let(:forty_person) { create :person, display_name: 'Forty', passed_asset_hours_requirement: true, vonage_tablet_approval_status: 0 }
    let!(:forty_person_area) { create :person_area, area: forty_area, person: forty_person }
    let(:forty_area) { create :area, project: forty_project }
    let(:forty_project) { create :project, name: 'Vonage Retail' }
    let!(:forty_shift) { create :shift, person: forty_person, date: Date.today - 3.hours, hours: 41 }

    let(:qualified_person) { create :person, display_name: 'Qualified', passed_asset_hours_requirement: false, vonage_tablet_approval_status: 2 }
    let!(:qualified_shift) { create :shift, person: qualified_person, hours: 41, date: Date.today - 3.hours }

    let(:denied_person) { create :person, passed_asset_hours_requirement: false, vonage_tablet_approval_status: 1 }
    let!(:denied_person_shift) { create :shift, person: denied_person, hours: 41, date: Date.today - 3.hours }

    let(:passing_forty_person) { create :person, display_name: 'Passing Forty ', passed_asset_hours_requirement: false, vonage_tablet_approval_status: 0 }
    let!(:passing_forty_person_shift) { create :shift, person: passing_forty_person, hours: 41, date: Date.today - 3.hours }

    let(:too_early_person) { create :person, display_name: 'Too Early', passed_asset_hours_requirement: false, vonage_tablet_approval_status: 0 }
    let!(:too_early_shift) { create :shift, person: too_early_person, hours: 41, date: Date.today - 3.days }
    before {
      @total = AssetShiftHoursTotaling.new(duration)
    }

    it 'ignores shifts from outside the duration' do
      expect {
        @total.generate_totals
        too_early_person.reload
      }.not_to change too_early_person, :passed_asset_hours_requirement
      expect {
        @total.generate_totals
        too_early_person.reload
      }.not_to change too_early_person, :vonage_tablet_approval_status
    end

    it 'ignores non-Vonage employees' do
      expect {
        @total.generate_totals
        non_vonage_person.reload
      }.not_to change non_vonage_person, :passed_asset_hours_requirement
      expect {
        @total.generate_totals
        non_vonage_person
      }.not_to change non_vonage_person, :vonage_tablet_approval_status
    end
    it 'ignores Vonage employees that are passed 40 hours' do
      expect {
        @total.generate_totals
        forty_person.reload
      }.not_to change forty_person, :passed_asset_hours_requirement
      expect {
        @total.generate_totals
        forty_person.reload
      }.not_to change forty_person, :vonage_tablet_approval_status
    end
    it 'ignores employees that are qualified or disqualified already' do
      expect {
        @total.generate_totals
        qualified_person.reload
      }.not_to change qualified_person, :passed_asset_hours_requirement
      expect {
        @total.generate_totals
        qualified_person.reload
      }.not_to change qualified_person, :vonage_tablet_approval_status
      expect {
        @total.generate_totals
        denied_person.reload
      }.not_to change denied_person, :passed_asset_hours_requirement
      expect {
        @total.generate_totals
        denied_person.reload
      }.not_to change denied_person, :vonage_tablet_approval_status
    end
    it 'totals the hours for the remaining employees' do
      expect {
        @total.generate_totals
        passing_forty_person.reload
      }.to change(passing_forty_person, :passed_asset_hours_requirement).to(true)
      expect {
        @total.generate_totals
        passing_forty_person.reload
      }.not_to change passing_forty_person, :vonage_tablet_approval_status
    end
  end
end