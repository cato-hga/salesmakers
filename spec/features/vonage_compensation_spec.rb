require 'rails_helper'

describe 'Vonage commission compensation' do
  include ActionView::Helpers

  let(:area) { create :area }
  let!(:paycheck) {
    create :vonage_paycheck,
           name: '2015-01-01 through 2015-01-15',
           wages_start: Date.new(2015, 1, 1),
           wages_end: Date.new(2015, 1, 15),
           commission_start: Date.new(2015, 1, 2),
           commission_end: Date.new(2015, 1, 14),
           cutoff: Time.now - 23.hours
  }
  let(:department) { create :department, name: 'Vonage Retail Sales' }
  let(:position) {
    create :position,
           name: 'Vonage Retail Sales Specialist',
           department: department
  }
  let(:person) { create :person, position: position }
  let!(:person_area) { create :person_area, person: person, area: area }
  let(:name) { person.display_name }
  let(:vonage_sale) {
    create :vonage_sale,
           person: person,
           sale_date: paycheck.commission_end - 1.week
  }

  before { CASClient::Frameworks::Rails::Filter.fake(person.email) }

  describe 'widgets showing' do
    before { visit commission_person_path(person) }

    it 'shows the correct page title' do
      expect(page).to have_selector('h1', text: "#{name}'s Commissions for 01/02/2015 - 01/14/2015")
    end

    it 'shows the sales widget' do
      expect(page).to have_selector('h3', text: "#{person.first_name}'s Sales")
    end

    it 'shows the refunds widget' do
      expect(page).to have_selector('h3', text: "#{person.first_name}'s Refunds")
    end

    it 'shows the commission summary widget' do
      expect(page).to have_selector('h3', text: 'Commission Summary')
    end
  end

  describe 'sales payouts' do
    let!(:vonage_sale_payout) {
      create :vonage_sale_payout,
             vonage_sale: vonage_sale,
             person: person,
             vonage_paycheck: paycheck
    }

    before { visit commission_person_path(person) }

    it 'shows the sale date' do
      expect(page).to have_content(vonage_sale.sale_date.strftime('%m/%d/%Y'))
    end

    it 'shows the MAC' do
      expect(page).to have_content(vonage_sale.mac)
    end

    it 'shows the location name' do
      expect(page).to have_content(vonage_sale.location.name)
    end

    it 'shows the customer name' do
      expect(page).to have_content("#{vonage_sale.customer_first_name} #{vonage_sale.customer_last_name}")
    end

    it 'shows the payout amount' do
      expect(page).to have_content(number_to_currency(vonage_sale_payout.payout))
    end
  end

  describe 'refunds' do
    let(:change) {
      create :vonage_account_status_change,
             mac: vonage_sale.mac,
             account_end_date: vonage_sale.sale_date + 1.day,
             status: :terminated,
             termination_reason: 'Dog ate service'
    }
    let!(:vonage_refund) {
      create :vonage_refund,
             vonage_sale: vonage_sale,
             refund_date: paycheck.commission_end - 3.days,
             vonage_account_status_change: change,
             person: person
    }
    let!(:vonage_sale_payout) {
      create :vonage_sale_payout,
             vonage_sale: vonage_sale,
             person: person,
             vonage_paycheck: paycheck
    }

    before { visit commission_person_path(person) }

    it 'shows the refund date' do
      expect(page).to have_content(vonage_refund.refund_date.strftime('%m/%d/%Y'))
    end

    it 'shows the MAC' do
      expect(page).to have_content(change.mac)
    end

    it 'shows the account_start_date' do
      expect(page).to have_content(change.account_start_date.strftime('%m/%d/%Y'))
    end

    it 'shows the status' do
      expect(page).to have_content('Terminated')
    end

    it 'shows the status change date' do
      expect(page).to have_content(change.created_at.apply_eastern_offset.strftime('%m/%d/%Y'))
    end

    it 'shows the termination reason' do
      expect(page).to have_content(change.termination_reason)
    end

    it 'shows the payout amount' do
      expect(page).to have_content(number_to_currency(-1 * vonage_sale_payout.payout))
    end

    it 'shows a total amount' do
      expect(page).to have_content('$0.00')
    end
  end

end