require_relative '../../app/contexts/asset_shift_hours_totaling'

describe AssetShiftHoursTotaling do
  #include ActiveJob::TestHelper

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
    it 'passes off to .email_managers' do
      expect(@total).to receive(:email_managers).with([passing_forty_person])
      @total.generate_totals
    end
  end

  describe '.email_managers' do
    let(:person_with_supervisor) { create :person, supervisor: direct_supervisor }
    let(:second_person_with_supervisor) { create :person, supervisor: direct_supervisor }
    let(:no_supervisor) { create :person, supervisor: nil, display_name: 'Orphaned' }
    let(:people) { [person, no_supervisor] }

    let(:other_people) { [no_supervisor] }
    let(:person) { create :person, display_name: 'Employee' }
    let(:direct_supervisor) { create :person, display_name: 'Direct Supervisor' }
    let(:market_supervisor) { create :person, display_name: 'Market Supervisor' }
    let(:regional_supervisor) { create :person, display_name: 'Regional Supervisor' }
    let(:area) { create :area, parent: market_area }
    let(:market_area) { create :area, parent: regional_area }
    let(:regional_area) { create :area }
    let!(:person_area) { create :person_area, area: area, person: person }
    let!(:supervisor_area) { create :person_area, area: area, person: direct_supervisor, manages: true }
    let!(:market_supervisor_area) { create :person_area, area: market_area, person: market_supervisor, manages: true }
    let!(:regional_supervisor_area) { create :person_area, area: regional_area, person: regional_supervisor, manages: true }

    it 'emails managers for all employees in the array generated by .generate_totals' do
      message_delivery = instance_double(ActionMailer::MessageDelivery)
      allow(message_delivery).to receive(:deliver_later)
      expect(AssetsMailer).to receive(:asset_approval_mailer).with(direct_supervisor).and_return(message_delivery)
      @total = AssetShiftHoursTotaling.new(duration)
      @total.email_managers(people)
    end
    it 'does not email managers twice if they have two people who passed 40 hours' do
      message_delivery = instance_double(ActionMailer::MessageDelivery)
      allow(message_delivery).to receive(:deliver_later)
      expect(AssetsMailer).to receive(:asset_approval_mailer).with(direct_supervisor).and_return(message_delivery).once
      @total = AssetShiftHoursTotaling.new(duration)
      @total.email_managers(people)
    end

    it 'emails the area manager of territory if there is not a direct supervisor' do
      supervisor_area.update manages: false
      supervisor_area.reload
      direct_supervisor.reload
      message_delivery = instance_double(ActionMailer::MessageDelivery)
      allow(message_delivery).to receive(:deliver_later)
      expect(AssetsMailer).to receive(:asset_approval_mailer).with(market_supervisor).and_return(message_delivery).once
      @total = AssetShiftHoursTotaling.new(duration)
      mailer = @total.email_managers(people)
    end

    it 'emails the regional manager if there is not an area manager' do
      supervisor_area.update manages: false
      supervisor_area.reload
      direct_supervisor.reload
      market_supervisor_area.update manages: false
      market_supervisor_area.reload
      market_supervisor.reload
      message_delivery = instance_double(ActionMailer::MessageDelivery)
      allow(message_delivery).to receive(:deliver_later)
      expect(AssetsMailer).to receive(:asset_approval_mailer).with(regional_supervisor).and_return(message_delivery).once
      @total = AssetShiftHoursTotaling.new(duration)
      mailer = @total.email_managers(people)
    end
    it 'emails IT if there is not a manager, area manager, or regional for an employee' do
      supervisor_area.update manages: false
      supervisor_area.reload
      direct_supervisor.reload
      market_supervisor_area.update manages: false
      market_supervisor_area.reload
      market_supervisor.reload
      regional_supervisor_area.update manages: false
      regional_supervisor_area.reload
      regional_supervisor.reload
      message_delivery = instance_double(ActionMailer::MessageDelivery)
      allow(message_delivery).to receive(:deliver_later)
      expect(AssetsMailer).to receive(:no_supervisors_for_asset_approval_mailer).and_return(message_delivery).once
      @total = AssetShiftHoursTotaling.new(duration)
      mailer = @total.email_managers([person])
    end
  end
end