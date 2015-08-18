require 'rails_helper'

describe 'Vonage compensation plan effective 07/01/2015' do
  let(:project) { create :project, name: 'Vonage Retail' }
  let(:area) { create :area, project: project }
  let(:rep) { create :person }
  let!(:person_area) { create :person_area, area: area, person: rep }

  let(:vonage_commission_period07012015) {
    create :vonage_commission_period07012015,
           hps_start: Date.today.beginning_of_month,
           hps_end: Date.today.end_of_month,
           vested_sales_start: Date.today.beginning_of_month - 1.month,
           vested_sales_end: Date.today.beginning_of_month - 1.day,
           cutoff: DateTime.now + 1.day
  }
  let!(:previous_vonage_commission_period07012015) {
    previous_vonage_commission_period07012015 = build :vonage_commission_period07012015,
           name: 'Previous Period',
           hps_start: Date.today.beginning_of_month - 1.month,
           hps_end: Date.today.end_of_month - 1.month,
           vested_sales_start: Date.today.beginning_of_month - 1.month - 1.month,
           vested_sales_end: Date.today.beginning_of_month - 1.day - 1.month,
           cutoff: DateTime.now + 1.day - 1.month
    previous_vonage_commission_period07012015.save validate: false
    previous_vonage_commission_period07012015
  }
  let!(:hps_vonage_sale) {
    hps_vonage_sale = build :vonage_sale, person: rep, sale_date: vonage_commission_period07012015.hps_start + 1.day, mac: '117788226644'
    hps_vonage_sale.save validate: false
    hps_vonage_sale
  }
  let!(:hps_vonage_sale_outside) { create :vonage_sale, person: rep, sale_date: vonage_commission_period07012015.hps_end + 1.day }
  let!(:vested_sales_vonage_sale) {
    vested_sales_vonage_sale = build :vonage_sale, person: rep, sale_date: vonage_commission_period07012015.vested_sales_start + 1.day
    vested_sales_vonage_sale.save validate: false
    vested_sales_vonage_sale
  }
  let!(:vested_sales_vonage_sale_outside) {
    vested_sales_vonage_sale_outside = build :vonage_sale, person: rep, sale_date: vonage_commission_period07012015.vested_sales_start - 1.day
    vested_sales_vonage_sale_outside.save validate: false
    vested_sales_vonage_sale_outside
  }
  let!(:hps_shift) { create :shift, hours: 8, date: vonage_commission_period07012015.hps_start + 1.day, person: rep, location: create(:location) }
  let!(:hps_shift_outside) { create :shift, date: vonage_commission_period07012015.hps_end + 1.day, person: rep, hours: 32.0 }
  let!(:vested_sales_shift) { create :shift, hours: 8, date: vonage_commission_period07012015.vested_sales_start + 1.day, person: rep, location: create(:location) }
  let!(:vested_sales_shift_outside) { create :shift, date: vonage_commission_period07012015.vested_sales_start - 1.day, person: rep }

  let!(:vonage_account_status_change) {
    create :vonage_account_status_change,
           mac: vested_sales_vonage_sale.mac,
           account_start_date: vested_sales_vonage_sale.sale_date
  }

  before do
    VonageComp07012015Processing.new.execute
    CASClient::Frameworks::Rails::Filter.fake(rep.email)
    visit vcp07012015_path(rep)
  end

  it 'has the correct title' do
    expect(page).to have_selector 'h1', text: "#{rep.display_name}'s Compensation for \"#{vonage_commission_period07012015.name}\""
  end

  it 'has the HPS period dates' do
    expect(page).to have_content "HPS period: #{vonage_commission_period07012015.hps_start.strftime('%-m/%-d')} to #{vonage_commission_period07012015.hps_end.strftime('%-m/%-d')}"
  end

  it 'has the vested sales period dates' do
    expect(page).to have_content "Vested sales period: #{vonage_commission_period07012015.vested_sales_start.strftime('%-m/%-d')} to #{vonage_commission_period07012015.vested_sales_end.strftime('%-m/%-d')}"
  end

  context 'for HPS' do
    it 'has the HPS shifts widget' do
      expect(page).to have_selector 'h3', text: 'HPS Period Shifts'
    end

    it 'has the HPS sales widget' do
      expect(page).to have_selector 'h3', text: 'HPS Period Sales'
    end

    it 'lists the shift date' do
      expect(page).to have_content hps_shift.date.strftime('%-m/%-d')
    end

    it 'lists the shift location' do
      expect(page).to have_content "#{hps_shift.location.channel.name} ##{hps_shift.location.store_number}"
    end

    it 'lists training if the shift is a training shift' do
      hps_shift.update training: true
      visit vcp07012015_path(rep)
      expect(page).to have_content "Training"
    end

    it 'lists the number of hours for the shift' do
      expect(page).to have_content hps_shift.hours.round(1).to_s
    end

    it 'lists the sale date' do
      expect(page).to have_content hps_vonage_sale.sale_date.strftime('%-m/%-d')
    end

    it 'lists the sale location' do
      expect(page).to have_content "#{hps_vonage_sale.location.channel.name} ##{hps_vonage_sale.location.store_number}"
    end

    it 'lists the sale MAC' do
      expect(page).to have_content hps_vonage_sale.mac
    end
  end

  context 'for vested sales' do
    it 'has the vested sales sales widget' do
      expect(page).to have_selector 'h3', text: 'Vested Sales Period Sales'
    end

    it 'lists the sale date' do
      expect(page).to have_content vested_sales_vonage_sale.sale_date.strftime('%-m/%-d')
    end

    it 'lists the sale location' do
      expect(page).to have_content "#{vested_sales_vonage_sale.location.channel.name} ##{vested_sales_vonage_sale.location.store_number}"
    end

    it 'lists the sale MAC' do
      expect(page).to have_content vested_sales_vonage_sale.mac
    end

    it 'lists whether the sale was vested or not' do
      expect(page).to have_selector 'i.fi-check'
    end
  end

  describe 'compensation totals' do
    it 'displays the totals widget' do
      expect(page).to have_selector 'h3', text: 'Totals'
    end

    it 'has the HPS section' do
      expect(page).to have_selector 'strong', text: 'HPS Period'
    end

    it 'has the Vested Sales section' do
      expect(page).to have_selector 'strong', text: 'Vested Sales Period'
    end

    it 'has the HPS totals' do
      within '#totals #hps' do
        expect(page).to have_selector '.hps_hours', text: '8.0'
        expect(page).to have_selector '.hps_sales', text: '1'
        expect(page).to have_selector '.hps_total', text: '8.0'
      end
    end

    it 'has the Vested Sales totals' do
      within '#totals #vested_sales' do
        expect(page).to have_selector '.vested_sales_sales', text: '1'
        expect(page).to have_selector '.vested_sales_vested_sales', text: '1'
        expect(page).to have_content '100%'
      end
    end

    it 'has the total totals' do
      within '#totals' do
        expect(page).to have_content '$3.00'
        expect(page).to have_content '$24.00'
      end
    end
  end

  describe 'switching periods' do
    before do
      select 'Previous Period', from: 'vonage_commission_period07012015_id'
      click_on 'Switch'
    end

    it 'shows the proper paycheck' do
      expect(page).to have_content "HPS period: #{previous_vonage_commission_period07012015.hps_start.strftime('%-m/%-d')} to #{previous_vonage_commission_period07012015.hps_end.strftime('%-m/%-d')}"
      expect(page).to have_content "Vested sales period: #{previous_vonage_commission_period07012015.vested_sales_start.strftime('%-m/%-d')} to #{previous_vonage_commission_period07012015.vested_sales_end.strftime('%-m/%-d')}"
    end
  end

  context 'no gross sales but has HPS' do
    it 'has the proper totals' do
      vonage_account_status_change
      vested_sales_vonage_sale.destroy
      visit vcp07012015_path(rep)
      within '#totals' do
        expect(page).to have_content '$1.50'
        expect(page).to have_content '$12.00'
      end
    end
  end

  context 'when rep has worked less than 40 hours' do
    it 'shows that the rep has not worked over 40 hours and is not eligible' do
      hps_shift_outside.destroy
      visit vcp07012015_path(rep)
      expect(page).to have_content 'You must have worked at least 40 hours to be eligible for commission.'
    end
  end
end
