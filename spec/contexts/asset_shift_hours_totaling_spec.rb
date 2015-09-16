require_relative '../../app/contexts/asset_shift_hours_totaling'

describe AssetShiftHoursTotaling do

  let(:duration) { 24.hours }

  describe '.initialize' do
    it 'sets the previous duration to search though for people to total' do
      expect(AssetShiftHoursTotaling).to receive(:new).and_return(24.hours)
      AssetShiftHoursTotaling.new(duration)
    end
  end

  describe '.generate_totals' do
    let(:sprint_prepaid_person) { create :person, display_name: 'Sprint Employee', passed_asset_hours_requirement: false, vonage_tablet_approval_status: 0 }
    let!(:sprint_prepaid_person_area) { create :person_area, area: sprint_prepaid_area, person: sprint_prepaid_person }
    let(:sprint_prepaid_area) { create :area, project: sprint_prepaid_project }
    let(:sprint_prepaid_project) { create :project, name: 'Sprint Retail' }
    let!(:sprint_prepaid_shift) { create :shift, person: sprint_prepaid_person, date: Date.today - 3.hours, hours: 41 }

    let(:ignore_person) { create :person, display_name: 'Ignore Me', passed_asset_hours_requirement: false, vonage_tablet_approval_status: 0 }
    let!(:ignore_person_area) { create :person_area, area: ignore_area, person: ignore_person }
    let(:ignore_area) { create :area, project: ignore_project }
    let(:ignore_project) { create :project, name: 'Ignored' }
    let!(:ignore_shift) { create :shift, person: ignore_person, date: Date.today - 3.hours, hours: 41 }


    let(:forty_person) { create :person, display_name: 'Forty', passed_asset_hours_requirement: true, vonage_tablet_approval_status: 0 }
    let!(:forty_person_area) { create :person_area, area: forty_area, person: forty_person }
    let(:forty_area) { create :area, project: forty_project }
    let(:forty_project) { create :project, name: 'Vonage' }
    let!(:forty_shift) { create :shift, person: forty_person, date: Date.today - 3.hours, hours: 41 }

    let(:qualified_person) { create :person, display_name: 'Qualified', passed_asset_hours_requirement: false, vonage_tablet_approval_status: 2 }
    let!(:qualified_shift) { create :shift, person: qualified_person, hours: 41, date: Date.today - 3.hours }

    let(:denied_person) { create :person, passed_asset_hours_requirement: false, vonage_tablet_approval_status: 1 }
    let!(:denied_person_shift) { create :shift, person: denied_person, hours: 41, date: Date.today - 3.hours }

    let(:passing_forty_person) { create :person, display_name: 'Passing Forty ', passed_asset_hours_requirement: false, vonage_tablet_approval_status: 0, supervisor: supervisor }
    let!(:passing_forty_person_shift) { create :shift, person: passing_forty_person, hours: 41, date: Date.today - 3.hours }
    let!(:passing_forty_person_area) { create :person_area, area: forty_area, person: passing_forty_person }
    let(:supervisor) { create :person }

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

    it 'ignores non-Vonage and Non-Sprint Prepaid employees' do
      expect {
        @total.generate_totals
        ignore_person.reload
      }.not_to change ignore_person, :passed_asset_hours_requirement
      expect {
        @total.generate_totals
        ignore_person.reload
      }.not_to change ignore_person, :vonage_tablet_approval_status
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
    it 'always passes the asset hours requirement for Sprint Prepaid employees' do
      expect {
        @total.generate_totals
        sprint_prepaid_person.reload
      }.to change(sprint_prepaid_person, :passed_asset_hours_requirement).to(true)
      expect {
        @total.generate_totals
        sprint_prepaid_person.reload
      }.not_to change sprint_prepaid_person, :vonage_tablet_approval_status
      expect {
        @total.generate_totals
        sprint_prepaid_person.reload
      }.not_to change sprint_prepaid_person, :sprint_prepaid_asset_approval_status
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

  describe '#generate_mailer' do
    let(:events_person) { create :person, passed_asset_hours_requirement: true }
    let(:retail_person) { create :person, passed_asset_hours_requirement: true }
    let(:prepaid_person) { create :person, passed_asset_hours_requirement: true }
    let!(:no_person_area_person) { create :person, passed_asset_hours_requirement: true }

    let(:events_area) { create :area, project: events_project }
    let(:retail_area) { create :area, project: retail_project }
    let(:prepaid_area) { create :area, project: prepaid_project }

    let(:events_project) { create :project, name: 'Vonage Events' }
    let(:retail_project) { create :project, name: 'Vonage' }
    let(:prepaid_project) { create :project, name: 'Sprint Retail' }

    let!(:events_person_area) { create :person_area, person: events_person, area: events_area, manages: false }
    let!(:retail_person_area) { create :person_area, person: retail_person, area: retail_area, manages: false }
    let!(:prepaid_person_area) { create :person_area, person: prepaid_person, area: prepaid_area, manages: false }

    let!(:events_manager_area) { create :person_area, person: events_manager, area: events_area, manages: true }
    let!(:retail_manager_area) { create :person_area, person: retail_manager, area: retail_area, manages: true }
    let!(:prepaid_manager_area) { create :person_area, person: prepaid_manager, area: prepaid_area, manages: true }

    let(:events_manager) { create :person, display_name: 'Events Manager' }
    let(:retail_manager) { create :person, display_name: 'Retal Manager' }
    let(:prepaid_manager) { create :person, display_name: 'Prepaid Manager' }

    it 'emails all supervisors with assets pending approval' do
      Sidekiq::Testing.inline!
      AssetShiftHoursTotaling.generate_mailer
      deliveries = ActionMailer::Base.deliveries
      expect(deliveries.count).to eq(3)
    end

    it 'handles those without a person_area' do

    end
  end
end