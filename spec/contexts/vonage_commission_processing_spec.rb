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
      expect(processor).to receive(:make_payout).at_least(:once)
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
      expect(processor).to receive(:change_payout_amount_for_manager)
      processor.process
    end

    it 'should have two payouts totaling $30' do
      processor.process
      sale_payouts = VonageSalePayout.all
      payout_total = 0.00
      sale_payouts.each { |payout| payout_total += payout.payout }
      expect(payout_total).to eq(30.00)
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
      }.not_to change(VonageSalePayout, :count)
    end
  end

  context 'saving payouts to the database' do
    it 'is performed as a part of processing' do
      expect(processor).to receive(:save_payouts)
      processor.process
    end

    it 'saves the payouts' do
      processor.process
      expect(VonageSalePayout.count).to eq(2)
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

end