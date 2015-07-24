require 'rails_helper'

describe VonageComp07012015Processing do
  let(:processor) { described_class.new }

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
  let!(:hps_vonage_sale) { create :vonage_sale, person: rep, sale_date: vonage_commission_period07012015.hps_start + 1.day }
  let!(:hps_vonage_sale_outside) { create :vonage_sale, person: rep, sale_date: vonage_commission_period07012015.hps_end + 1.day }
  let!(:vested_sales_vonage_sale) { create :vonage_sale, person: rep, sale_date: vonage_commission_period07012015.vested_sales_start + 1.day }
  let!(:vested_sales_vonage_sale_outside) { create :vonage_sale, person: rep, sale_date: vonage_commission_period07012015.vested_sales_start - 1.day }
  let!(:hps_shift) { create :shift, hours: 8, date: vonage_commission_period07012015.hps_start + 1.day, person: rep }
  let!(:hps_shift_outside) { create :shift, date: vonage_commission_period07012015.hps_end + 1.day, person: rep }
  let!(:vested_sales_shift) { create :shift, hours: 8, date: vonage_commission_period07012015.vested_sales_start + 1.day, person: rep }
  let!(:vested_sales_shift_outside) { create :shift, date: vonage_commission_period07012015.vested_sales_start - 1.day, person: rep }

  before { processor }

  subject { processor.execute }

  it 'creates the correct number of HPS shifts' do
    expect {
      subject
    }.to change(VCP07012015HPSShift, :count).from(0).to(1)
  end

  it 'creates the correct number of HPS sales' do
    expect {
      subject
    }.to change(VCP07012015HPSSale, :count).from(0).to(1)
  end

  it 'creates the correct number of vested sales shifts' do
    expect {
      subject
    }.to change(VCP07012015VestedSalesShift, :count).from(0).to(1)
  end

  it 'creates the correct number of vested sales sales' do
    expect {
      subject
    }.to change(VCP07012015VestedSalesSale, :count).from(0).to(1)
  end

  it 'does not mark the vested sales sales vested if they are not vested' do
    subject
    expect(VCP07012015VestedSalesSale.first.vested).to eq(false)
  end

  it 'marks the vested sales sale vested if it is vested' do
    create :vonage_account_status_change,
           mac: vested_sales_vonage_sale.mac,
           account_start_date: vested_sales_vonage_sale.sale_date
    subject
    expect(VCP07012015VestedSalesSale.first.vested).to eq(true)
  end
end
