require 'rails_helper'

describe ComcastSale do
  let!(:other_sale) { create :comcast_sale, order_number: '1234567891000' }
  subject { build :comcast_sale }

  it 'is valid with correct attributes' do
    expect(subject).to be_valid
  end

  it 'requires at least one of tv, internet, phone, or security' do
    subject.tv = false
    subject.internet = false
    subject.security = false
    subject.phone = false
    expect(subject).not_to be_valid
    subject.tv = true
    expect(subject).to be_valid
    subject.tv = false; subject.internet = true
    expect(subject).to be_valid
    subject.internet = false; subject.security = true
    expect(subject).to be_valid
    subject.security = false; subject.phone = true
    expect(subject).to be_valid
  end

  it 'requires a Comcast install appointment' do
    subject.comcast_install_appointment = nil
    expect(subject).not_to be_valid
  end

  it 'does not allow a sale to be future-dated' do
    subject.order_date = Date.today + 1.day
    expect(subject).not_to be_valid
  end

  it 'requires a 13 digit order number with only digits' do
    subject.order_number = '12345678901234'
    expect(subject).not_to be_valid
    subject.order_number = '123456789012A'
    expect(subject).not_to be_valid
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


  it 'does not allow sales to be entered after more than 24 hours' do
    subject.order_date = Date.today
    expect(subject).to be_valid
    subject.order_date = Date.today - 1.day
    expect(subject).to be_valid
    subject.order_date = Date.today - 2.days
    expect(subject).not_to be_valid
  end

  describe 'scopes' do
    let!(:recent_installation) do
      sale = build :comcast_sale
      sale.comcast_install_appointment.install_date = Date.yesterday
      sale.save validate: false
      sale
    end
    let!(:upcoming_installation) do
      sale = create :comcast_sale
      sale.comcast_install_appointment.update install_date: Date.tomorrow
      sale
    end

    it 'scopes recent installation sales' do
      recent_installations = ComcastSale.recent_installations
      expect(recent_installations).to include(recent_installation)
      expect(recent_installations).not_to include(upcoming_installation)
    end

    it 'scopes upcoming installation sales' do
      upcoming_installations = ComcastSale.upcoming_installations
      expect(upcoming_installations).to include(upcoming_installation)
      expect(upcoming_installations).not_to include(recent_installation)
    end
  end
end