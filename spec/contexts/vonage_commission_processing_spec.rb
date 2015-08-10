require 'spec_helper'
require_relative '../../app/contexts/vonage_commission_processing'

describe VonageCommissionProcessing do
  let!(:paycheck) {
    create :vonage_paycheck,
           wages_start: Date.today - 1.week,
           wages_end: Date.today + 1.week,
           commission_start: Date.today - 1.week,
           commission_end: Date.today + 1.week,
           cutoff: DateTime.now + 1.week + 1.day
  }
  let(:old_paycheck) {
    create :vonage_paycheck,
           name: 'Old Paycheck',
           wages_start: paycheck.wages_start - 4.weeks,
           wages_end: paycheck.wages_end - 4.weeks,
           commission_start: paycheck.commission_start - 4.weeks,
           commission_end: paycheck.commission_end - 4.weeks,
           cutoff: paycheck.cutoff - 4.weeks + 1.day
  }
  let(:future_paycheck) {
    create :vonage_paycheck,
           name: 'Future Paycheck',
           wages_start: paycheck.wages_start + 4.weeks,
           wages_end: paycheck.wages_end + 4.weeks,
           commission_start: paycheck.commission_start + 4.weeks,
           commission_end: paycheck.commission_end + 4.weeks,
           cutoff: paycheck.cutoff + 4.weeks + 1.day
  }
  let!(:vonage_sale) {
    create :vonage_sale,
           sale_date: paycheck.commission_start + 1.day
  }
  let(:old_vonage_sale) {
    create :vonage_sale,
           person: vonage_sale.person,
           sale_date: old_paycheck.commission_start + 1.day,
           mac: 'FEDCBA654321'
  }
  let(:rev_share_vonage_sale) {
    create :vonage_sale,
           person: vonage_sale.person,
           sale_date: paycheck.commission_end - 64.days,
           mac: 'FEDFED123123'
  }
  let!(:rev_share_active_status) {
    create :vonage_account_status_change,
           mac: rev_share_vonage_sale.mac,
           account_start_date: paycheck.commission_start - 62.days,
           account_end_date: paycheck.commission_start + 100.years,
           status: :active
  }
  let(:rev_share_disconnected_sale) {
    create :vonage_sale,
           person: vonage_sale.person,
           sale_date: paycheck.commission_end - 94.days,
           mac: 'FEDFED321321'
  }
  let!(:rev_share_disconnected_status) {
    create :vonage_account_status_change,
           mac: rev_share_disconnected_sale.mac,
           account_start_date: paycheck.commission_start - 62.days,
           account_end_date: paycheck.commission_start - 22.days
  }
  let(:vonage_retail) { create :project, name: 'Vonage Retail' }
  let!(:vonage_events) { create :project, name: 'Vonage Events' }
  let(:area) { create :area, project: vonage_retail }
  let(:sub_area) { create :area, name: 'Sub-area', project: vonage_retail }
  let!(:person_area) {
    create :person_area,
           person: vonage_sale.person,
           area: sub_area
  }
  let!(:vonage_rep_sale_payout_bracket) {
    create :vonage_rep_sale_payout_bracket,
           area: area,
           sales_minimum: 0,
           sales_maximum: 2,
           per_sale: 10.00
  }
  let!(:previous_vonage_paycheck_negative_balance) {
    create :vonage_paycheck_negative_balance,
           vonage_paycheck: old_paycheck,
           person: vonage_sale.person,
           balance: -15.00
  }
  let!(:old_vonage_sale_payout) {
    create :vonage_sale_payout,
           vonage_paycheck: old_paycheck,
           person: vonage_sale.person,
           vonage_sale: old_vonage_sale,
           payout: 10.00
  }
  let!(:vonage_paycheck_negative_balance) {
    create :vonage_paycheck_negative_balance,
           vonage_paycheck: paycheck,
           person: vonage_sale.person,
           balance: -10.00
  }
  let(:processor) { VonageCommissionProcessing.new }

  before do
    sub_area.update parent: area
  end

  it 'determines the current paycheck' do
    old_paycheck; future_paycheck
    expect(processor).to receive(:get_paycheck).and_return(paycheck)
    processor.process
  end

  describe 'payout generation' do
    it 'is started by processing' do
      expect(processor).to receive(:generate_payouts)
      processor.process
    end

    it 'gets the VonageSales for the commission period' do
      expect(VonageSale).to receive(:for_paycheck).and_return(VonageSale.all)
      processor.process
    end

    it 'determines weeks in the paycheck' do
      expect(processor).to receive(:determine_weeks)
      processor.process
    end

    it 'splits sales into weeks' do
      expect(processor).to receive(:split_sales_into_weeks)
      processor.process
    end

    it 'generates payouts for weeks' do
      expect(processor).to receive(:generate_payouts_for_weeks)
      processor.process
    end

    it 'generates revenue sharing payouts' do
      expect(processor).to receive(:generate_revenue_sharing_payouts)
      processor.process
    end

    it 'sets an array of People that had VonageSales for the period' do
      expect(processor).to receive(:set_people_with_sales).exactly(2).times
      processor.process
    end

    it 'sets an hash with the count of sales for each person' do
      expect(processor).to receive(:set_sale_count_for_each_person).exactly(2).times
      processor.process
    end

    it 'sets the area with brackets closest up the tree for each person' do
      expect(processor).to receive(:set_bracket_area_for_each_person).exactly(2).times
      processor.process
    end

    it 'determines the bracket area for a person' do
      expect(processor).to receive(:get_bracket_area).and_return(area).at_least(:once)
      processor.process
    end

    it 'sets the bracket for each person' do
      expect(processor).to receive(:set_bracket_for_each_person).exactly(2).times
      processor.process
    end

    it 'determines the bracket for each sale count' do
      expect(processor).to receive(:get_bracket).and_return(vonage_rep_sale_payout_bracket).at_least(:once)
      processor.process
    end

    it 'makes the payouts from the person counts with brackets' do
      expect(processor).to receive(:make_payouts_from_counts).exactly(2).times
      processor.process
    end

    it 'makes payouts for a person from the count' do
      expect(processor).to receive(:make_payouts_from_count).at_least(:once)
      processor.process
    end

    it 'makes an individual payout from a person, sale, and payout' do
      expect(processor).to receive(:make_payout).exactly(:once)
      processor.process
    end
  end

  context 'revenue sharing payout generation' do
    it 'generates payouts for each milestone' do
      expect(processor).to receive(:generate_payouts_for_milestone).exactly(4).times
      processor.process
    end

    it 'gets the VonageSales for each milestone' do
      expect(VonageSale).to receive(:for_date_range).exactly(4).times
      processor.process
    end

    it 'processes sales for revenue sharing' do
      expect(processor).to receive(:process_revenue_sharing_payout_for_sales).exactly(4).times
      processor.process
    end

    it 'processes the payout for a sale that meets the criteria' do
      expect(processor).to receive(:process_revenue_sharing_payout_for_sale)
      processor.process
    end

    it 'makes the revenue sharing payout' do
      expect(processor).to receive(:make_revenue_sharing_payout)
      processor.process
    end

    it 'does not create revenue sharing payouts for inactive employees' do
      rev_share_vonage_sale.person.update active: false
      expect(processor).not_to receive(:make_revenue_sharing_payout)
      processor.process
    end
  end

  context 'changing manager payouts' do
    before { person_area.update manages: true }

    it 'changes manager payout amounts' do
      expect(processor).to receive(:change_manager_payouts)
      processor.process
    end

    it 'gets a list of Vonage managers' do
      expect(processor).to receive(:determine_vonage_managers)
      processor.process
    end

    it 'changes Vonage manager payout amounts' do
      expect(processor).to receive(:change_vonage_manager_payout_amounts)
      processor.process
    end

    it 'changes the payout amount for a Vonage manager' do
      expect(processor).to receive(:change_payout_amount_for_manager).exactly(:twice)
      processor.process
    end

    it 'should have two payouts totaling $32.50' do
      processor.process
      sale_payouts = VonageSalePayout.all
      payout_total = 0.00
      sale_payouts.each { |payout| payout_total += payout.payout }
      expect(payout_total).to eq(32.50)
    end
  end

  context 'clearing old payouts' do
    it 'is performed as part of processing' do
      expect(processor).to receive(:clear_existing_payouts)
      processor.process
    end

    it 'clears payouts from the database before writing new ones' do
      create :vonage_sale_payout, vonage_paycheck: paycheck
      expect {
        processor.process
      }.to change(VonageSalePayout, :count).from(2).to(3)
    end
  end

  context 'saving payouts to the database' do
    it 'is performed as a part of processing' do
      expect(processor).to receive(:save_payouts)
      processor.process
    end

    it 'saves the payouts' do
      processor.process
      expect(VonageSalePayout.count).to eq(3)
    end
  end

  describe 'carrying over of negative balances' do
    it 'is performed as part of processing' do
      expect(processor).to receive(:process_negative_balances)
      processor.process
    end

    it 'gathers people with refunds, sales, and negative balances' do
      expect(processor).to receive(:gather_person_list_for_balances)
      processor.process
    end

    it 'gathers a list of all those with refunds' do
      expect(processor).to receive(:gather_people_with_refunds)
      processor.process
    end

    it 'gathers a list of all those with negative balances' do
      expect(processor).to receive(:gather_people_with_balances)
      processor.process
    end

    it 'gets a hash of people with their last paycheck net amount' do
      expect(processor).to receive(:make_negative_payout_hashes)
      processor.process
    end

    it 'applies negative payout hashes to current paycheck' do
      expect(processor).to receive(:apply_negative_payout_hashes)
      processor.process
    end

    it 'clears existing negative balances' do
      expect {
        processor.process
      }.not_to change(VonagePaycheckNegativeBalance, :count)
    end

    it 'calls create_negative_balance' do
      expect(processor).to receive(:create_negative_balance)
      processor.process
    end

    it 'creates the negative balances' do
      processor.process
      expect(paycheck.vonage_paycheck_negative_balances.first.balance).to eq(-5.00)
    end

    it 'does not duplicate payouts on subsequent processings' do
      processor.process
      processor.process
      expect(paycheck.vonage_paycheck_negative_balances.count).to eq(1)
    end
  end

  context 'for non-comissioned employees' do
    let(:pilot_area) { create :area, project: vonage_retail }
    let(:pilot_sub_area) { create :area, name: 'Pilot Sub-area', project: vonage_retail }
    let(:pilot_person_area) { create :person_area, person: vonage_sale.person, area: pilot_sub_area }
    let!(:pilot_rep_sale_payout_bracket) {
      create :vonage_rep_sale_payout_bracket,
             area: pilot_area,
             sales_minimum: 0,
             sales_maximum: 2,
             per_sale: 10.00
    }
    let(:non_commissioned_person) {
      create :person
    }
    let!(:non_commissioned_person_pay_rate) {
      create :person_pay_rate,
             rate: 12.0,
             person: vonage_sale.person
    }

    before { pilot_sub_area.update parent: pilot_area }

    it 'does not make payouts for non-commissioned employees' do
      expect(processor).not_to receive(:make_payout)
      processor.process
    end

    it 'still makes payouts for Pilot employees at $12.00/hr. rate' do
      vonage_sale.person.person_areas.destroy_all
      vonage_sale.person.person_areas << pilot_person_area
      expect(processor).to receive(:make_payout).exactly(:once)
      processor.process
    end
  end
end