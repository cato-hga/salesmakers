require 'rails_helper'

describe 'Vonage sales actions' do
  include ActionView::Helpers
  include ApplicationHelper

  let!(:vonage_mac_prefix) { create :vonage_mac_prefix }
  let(:manager) { create :person, position: position }
  let(:rep) { create :person, position: position }
  let!(:manager_person_area) { create :person_area, area: area_one, person: manager, manages: true }
  let(:area_one) { create :area, project: vonage_retail }
  let(:vonage_retail) { create :project, name: 'Vonage' }
  let(:other_project_area) { create :area, project: other_project }
  let(:other_project) { create :project, name: 'Sprint Retail' }
  let!(:rep_person_area) { create :person_area, area: area_one, person: rep }
  let(:position) { create :position, permissions: [index_permission] }
  let(:index_permission) { create :permission, key: 'vonage_sale_index' }

  context 'when viewing the index' do
    let(:gift_card_override) { create :gift_card_override }
    let!(:rep_vonage_sale) { create :vonage_sale, person: rep, vested: true, gift_card_number: gift_card_override.override_card_number }
    let(:rep_from_another_area) { create :person }
    let!(:rep_from_another_area_person_area) { create :person_area, area: area_two, person: rep_from_another_area }
    let(:area_two) { create :area }
    let!(:location_area_one) { create :location_area, area: area_one, location: rep_vonage_sale.location }
    let!(:other_project_location_area) { create :location_area, area: other_project_area, location: rep_vonage_sale.location }
    let!(:rep_from_another_area_vonage_sale) { create :vonage_sale, person: rep_from_another_area }

    describe 'as a rep' do
      before do
        CASClient::Frameworks::Rails::Filter.fake(rep.email)
        visit vonage_sales_path
      end

      it 'has the sale date' do
        expect(page).to have_content rep_vonage_sale.sale_date.strftime('%m/%d/%Y')
      end

      it 'has the seller name' do
        expect(page).to have_selector 'a', text: rep.display_name
      end

      it 'has the MAC ID of the sale' do
        expect(page).to have_selector 'a', text: rep_vonage_sale.mac
      end

      it 'has the location' do
        expect(page).to have_selector 'a', text: rep_vonage_sale.location.name
      end

      it 'has the customer name' do
        expect(page).to have_content rep_vonage_sale.customer_first_name + " " + rep_vonage_sale.customer_last_name
      end

      it 'has the product type' do
        expect(page).to have_content rep_vonage_sale.vonage_product.name
      end

      it 'has the last four of the gift card' do
        expect(page).to have_content gift_card_override.override_card_number[12..15]
      end

      it 'has the location area name' do
        expect(page).to have_content area_one.name
      end

      it 'does not have the location area name of other projects' do
        expect(page).not_to have_content other_project_area.name
      end

      it 'indicates whether the sale is vested or not' do
        expect(page).to have_selector 'i[class="fi-check"]'
      end
    end

    describe 'as a manager' do
      before do
        CASClient::Frameworks::Rails::Filter.fake manager.email
        visit vonage_sales_path
      end

      it 'shows the proper devices' do
        expect(page).to have_content rep_vonage_sale.mac
      end

      it 'does not show devices from outside the area' do
        expect(page).not_to have_content rep_from_another_area_vonage_sale.mac
      end
    end

    describe 'as someone with all field visibility' do
      let(:it_tech) { create :it_tech_person }

      before do
        it_tech.position.permissions << index_permission
        CASClient::Frameworks::Rails::Filter.fake(it_tech.email)
        visit vonage_sales_path
      end

      it 'should display all devices' do
        expect(page).to have_content rep_vonage_sale.mac
        expect(page).to have_content rep_from_another_area_vonage_sale.mac
      end
    end
  end

  context 'when viewing a single sale' do
    let!(:walmart_gift_card) {
      create :walmart_gift_card,
             card_number: '1122334455667788',
             store_number: vonage_sale.location.store_number,
             used: true,
             balance: 0.93,
             purchase_date: Date.yesterday
    }
    let(:vonage_sale) { create :vonage_sale, creator: manager, person: rep, gift_card_number: '1122334455667788' }
    let!(:vonage_account_status_change_activation) { create :vonage_account_status_change, mac: vonage_sale.mac, created_at: DateTime.now - 48.hours }
    let!(:vonage_account_status_change_grace) { create :vonage_account_status_change, mac: vonage_sale.mac, status: 'grace', created_at: DateTime.now - 36.hours }
    let!(:vonage_account_status_change_suspended) { create :vonage_account_status_change, mac: vonage_sale.mac, status: 'suspended', created_at: DateTime.now - 1.day }
    let!(:vonage_account_status_change_termination) {
      create :vonage_account_status_change,
             mac: vonage_sale.mac,
             status: 'terminated',
             account_end_date: Date.today,
             termination_reason: 'Some termination reason'
    }
    let!(:location_area_one) { create :location_area, area: area_one, location: vonage_sale.location }

    before do
      allow_any_instance_of(WalmartGiftCard).to receive(:check).and_return(true)
      CASClient::Frameworks::Rails::Filter.fake rep.email
      visit vonage_sale_path(vonage_sale)
    end

    it 'has the correct title' do
      expect(page).to have_selector 'h1', text: vonage_sale.mac
    end

    it 'has the sale date' do
      expect(page).to have_content vonage_sale.sale_date.strftime('%m/%d/%Y')
    end
    
    it 'has the creation date' do
      expect(page).to have_content vonage_sale.created_at.strftime('%m/%d/%Y %-l:%M%P')
    end

    it 'has the seller name' do
      expect(page).to have_selector 'a', text: rep.display_name
    end
    
    it 'has the creator name' do
      expect(page).to have_selector 'a', text: manager.display_name
    end

    it 'has the location' do
      expect(page).to have_selector 'a', text: vonage_sale.location.name
    end

    it 'has the customer name' do
      expect(page).to have_content vonage_sale.customer_first_name + " " + vonage_sale.customer_last_name
    end

    it 'has the product type' do
      expect(page).to have_content vonage_sale.vonage_product.name
    end

    it 'has the location area name' do
      expect(page).to have_content area_one.name
    end

    it 'indicates whether the sale is vested or not' do
      expect(page).to have_selector 'i[class="fi-x"]'
    end

    it 'has VonageAccountStatusChange information' do
      expect(page).to have_content 'Active'
      expect(page).to have_content 'Grace'
      expect(page).to have_content 'Suspended'
      expect(page).to have_content 'Terminated'
      expect(page).to have_content vonage_account_status_change_activation.created_at.strftime('%m/%d/%Y %-l:%M%P')
      expect(page).to have_content vonage_account_status_change_grace.created_at.strftime('%m/%d/%Y %-l:%M%P')
      expect(page).to have_content vonage_account_status_change_suspended.created_at.strftime('%m/%d/%Y %-l:%M%P')
      expect(page).to have_content vonage_account_status_change_termination.created_at.strftime('%m/%d/%Y %-l:%M%P')
      expect(page).to have_content vonage_account_status_change_termination.account_end_date.strftime('%m/%d/%Y')
      expect(page).to have_content vonage_account_status_change_termination.termination_reason
    end

    it 'has the gift card information' do
      expect(page).to have_content walmart_gift_card.card_number.insert(4, '-').insert(9, '-').insert(14, '-')
      expect(page).to have_content number_to_currency(walmart_gift_card.balance)
      expect(page).to have_content short_date(walmart_gift_card.purchase_date)
      expect(page).to have_content number_to_currency(walmart_gift_card.purchase_amount)
      expect(page).to have_content walmart_gift_card.store_number
      expect(page).to have_selector "a[href='#{walmart_gift_card.link.sub('https://getegiftcard.walmart.com/gift-card/view/', 'http://rbdconnect.com/gc/l/?link=')}'].button",
                                    text: 'View Gift Card Page'
    end
  end
end