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
  let!(:hps_vonage_sale) { create :vonage_sale, person: rep, sale_date: vonage_commission_period07012015.hps_start + 1.day, mac: '117788226644' }
  let!(:hps_vonage_sale_outside) { create :vonage_sale, person: rep, sale_date: vonage_commission_period07012015.hps_end + 1.day }
  let!(:vested_sales_vonage_sale) { create :vonage_sale, person: rep, sale_date: vonage_commission_period07012015.vested_sales_start + 1.day }
  let!(:vested_sales_vonage_sale_outside) { create :vonage_sale, person: rep, sale_date: vonage_commission_period07012015.vested_sales_start - 1.day }
  let!(:hps_shift) { create :shift, hours: 8, date: vonage_commission_period07012015.hps_start + 1.day, person: rep, location: create(:location) }
  let!(:hps_shift_outside) { create :shift, date: vonage_commission_period07012015.hps_end + 1.day, person: rep }
  let!(:vested_sales_shift) { create :shift, hours: 8, date: vonage_commission_period07012015.vested_sales_start + 1.day, person: rep }
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
    expect(page).to have_selector 'h1', text: "#{rep.display_name}'s Compensation for #{vonage_commission_period07012015.name}"
  end

  it 'has the HPS period dates' do
    expect(page).to have_content "HPS period: #{vonage_commission_period07012015.hps_start.strftime('%m/%d/%Y')} to #{vonage_commission_period07012015.hps_end.strftime('%m/%d/%Y')}"
  end

  it 'has the vested sales period dates' do
    expect(page).to have_content "Vested sales period: #{vonage_commission_period07012015.vested_sales_start.strftime('%m/%d/%Y')} to #{vonage_commission_period07012015.vested_sales_end.strftime('%m/%d/%Y')}"
  end

  context 'for HPS' do
    it 'has the HPS shifts widget' do
      expect(page).to have_selector 'h3', text: 'HPS Period Shifts'
    end

    it 'has the HPS sales widget' do
      expect(page).to have_selector 'h3', text: 'HPS Period Sales'
    end

    it 'lists the shift date' do
      expect(page).to have_content hps_shift.date.strftime('%m/%d/%Y')
    end

    it 'lists the shift location' do
      expect(page).to have_content hps_shift.location.name
    end

    it 'lists the number of hours for the shift' do
      expect(page).to have_content hps_shift.hours.round(1).to_s
    end

    it 'lists the sale date' do
      expect(page).to have_content hps_sale.sale_date.strftime('%m/%d/%Y')
    end

    it 'lists the sale MAC' do
      expect(page).to have_content hps_sale.vonage_sale.mac
    end
  end

  context 'for vested sales' do
    it 'has the vested sales sales widget' do
      expect(page).to have_selector 'h3', text: 'Vested Sales Period Sales'
    end

    it 'lists the sale date' do
      expect(page).to have_content hps_sale.sale_date.strftime('%m/%d/%Y')
    end

    it 'lists the sale MAC' do
      expect(page).to have_content hps_sale.vonage_sale.mac
    end

    it 'lists whether the sale was vested or not' do
      expect(page).to have_selector 'i.fi-check'
    end
  end
end