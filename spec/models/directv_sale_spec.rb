# == Schema Information
#
# Table name: directv_sales
#
#  id                         :integer          not null, primary key
#  order_date                 :date             not null
#  person_id                  :integer
#  directv_customer_id        :integer          not null
#  order_number               :string           not null
#  directv_former_provider_id :integer
#  directv_lead_id            :integer
#  customer_acknowledged      :boolean          default(FALSE), not null
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#

require 'rails_helper'

describe DirecTVSale do
  let!(:other_sale) { create :directv_sale, order_number: '1234567891000' }
  subject { build :directv_sale }

  it 'is valid with correct attributes' do
    expect(subject).to be_valid
  end

  it 'requires a DirecTV install appointment' do
    subject.directv_install_appointment = nil
    expect(subject).not_to be_valid
  end

  it 'does not allow a sale to be future-dated' do
    subject.order_date = Date.today + 1.day
    expect(subject).not_to be_valid
  end

  it 'does not allow install date to be past-dated' do
    subject.directv_install_appointment.install_date = Date.yesterday
    expect(subject).not_to be_valid
  end

  it 'does not allow date to be future-dated more than 60 days.' do
    subject.directv_install_appointment.install_date = 61.days.from_now
    expect(subject).not_to be_valid
  end

  it 'requires an order number with only digits' do
    subject.order_number = '1234567890123A'
    expect(subject).not_to be_valid
    subject.order_number = '1234567890123'
    expect(subject).to be_valid
  end

  it 'has a unique order number' do
    subject.order_number = '1234567891000'
    expect(other_sale).to be_valid
    expect(subject).not_to be_valid
  end


  it 'does not allow sales to be entered after more than 24 hours', pending: 'temporarily removed' do
    subject.order_date = Date.today
    expect(subject).to be_valid
    subject.order_date = Date.today - 1.day
    expect(subject).to be_valid
    subject.order_date = Date.today - 2.days
    expect(subject).not_to be_valid
  end

  describe 'scopes' do
    let!(:recent_installation) do
      sale = build :directv_sale
      sale.directv_install_appointment.install_date = Date.yesterday
      sale.order_date = Date.yesterday
      sale.save validate: false
      sale
    end
    let!(:upcoming_installation) do
      sale = create :directv_sale
      sale.directv_install_appointment.update install_date: Date.tomorrow
      sale.update order_date: Date.tomorrow
      sale
    end

    it 'scopes recent installation orders' do
      recent_installations = DirecTVSale.recent_installations
      expect(recent_installations).to include(recent_installation)
      expect(recent_installations).not_to include(upcoming_installation)
    end

    it 'scopes upcoming installation orders' do
      upcoming_installations = DirecTVSale.upcoming_installations
      expect(upcoming_installations).to include(upcoming_installation)
      expect(upcoming_installations).not_to include(recent_installation)
    end

    it 'pulls orders for a date range' do
      yesterday_sales = DirecTVSale.sold_between_dates(Date.yesterday, Date.today)
      expect(DirecTVSale.count).to eq(3)
      expect(yesterday_sales.count).to eq(1)
    end
  end
end
