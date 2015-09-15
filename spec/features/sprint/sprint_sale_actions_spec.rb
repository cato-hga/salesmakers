require 'rails_helper'

describe 'Sprint sales actions' do
  include ActionView::Helpers
  include ApplicationHelper

  let(:manager) { create :person, position: position }
  let(:rep) { create :person, position: position }
  let!(:manager_person_area) { create :person_area, area: area_one, person: manager, manages: true }
  let(:area_one) { create :area, project: sprint_retail }
  let(:sprint_retail) { create :project, name: 'Sprint Retail' }
  let(:other_project_area) { create :area, project: other_project }
  let(:other_project) { create :project, name: 'Sprint Retail' }
  let!(:postpaid_project) { create :project, name: 'Sprint Postpaid' }
  let!(:rep_person_area) { create :person_area, area: area_one, person: rep }
  let(:position) { create :position, permissions: [index_permission] }
  let(:index_permission) { create :permission, key: 'sprint_sale_index' }

  context 'when viewing the index' do
    let!(:rep_sprint_sale) {
      create :sprint_sale,
             person: rep,
             mobile_phone: '8635214572',
             phone_activated_in_store: true,
             upgrade: false
    }
    let(:rep_from_another_area) { create :person }
    let!(:rep_from_another_area_person_area) { create :person_area, area: area_two, person: rep_from_another_area }
    let(:area_two) { create :area }
    let!(:location_area_one) { create :location_area, area: area_one, location: rep_sprint_sale.location }
    let!(:other_project_location_area) { create :location_area, area: other_project_area, location: rep_sprint_sale.location }
    let!(:rep_from_another_area_sprint_sale) { create :sprint_sale, person: rep_from_another_area }

    describe 'as a rep' do
      before do
        CASClient::Frameworks::Rails::Filter.fake(rep.email)
        visit sprint_sales_path
      end

      it 'has the sale date' do
        expect(page).to have_content rep_sprint_sale.sale_date.strftime('%m/%d/%Y')
      end

      it 'has the seller name' do
        expect(page).to have_selector 'a', text: rep.display_name
      end

      it 'has the MEID of the sale' do
        expect(page).to have_selector 'a', text: rep_sprint_sale.meid
      end

      it 'has the carrier' do
        expect(page).to have_content rep_sprint_sale.sprint_carrier.name
      end

      it 'has the handset model' do
        expect(page).to have_content rep_sprint_sale.sprint_handset.name
      end

      it 'has the rate plan' do
        expect(page).to have_content rep_sprint_sale.sprint_rate_plan.name
      end

      it 'has the mobile phone' do
        phone = rep_sprint_sale.mobile_phone
        expect(page).to have_selector 'a', text: "(#{phone[0..2]}) #{phone[3..5]}-#{phone[6..9]}"
      end

      it 'has the location' do
        expect(page).to have_selector 'a', text: rep_sprint_sale.location.name
      end

      it 'has the location area name' do
        expect(page).to have_content area_one.name
      end

      it 'does not have the location area name of other projects' do
        expect(page).not_to have_content other_project_area.name
      end

      it 'indicates new activations' do
        expect(page).to have_selector 'i[class="fi-check"]'
      end
    end

    describe 'as a manager' do
      before do
        CASClient::Frameworks::Rails::Filter.fake manager.email
        visit sprint_sales_path
      end

      it 'shows the proper devices' do
        expect(page).to have_content rep_sprint_sale.meid
      end

      it 'does not show devices from outside the area' do
        expect(page).not_to have_content rep_from_another_area_sprint_sale.meid
      end
    end

  end

  context 'when viewing a single sale' do
    let!(:sprint_sale) {
      create :sprint_sale,
             person: rep,
             mobile_phone: '8635214572',
             phone_activated_in_store: false,
             reason_not_activated_in_store: 'Balls',
             upgrade: false
    }
    let!(:location_area_one) { create :location_area, area: area_one, location: sprint_sale.location }

    before do
      CASClient::Frameworks::Rails::Filter.fake rep.email
      visit sprint_sale_path(sprint_sale)
    end

    it 'has the correct title' do
      expect(page).to have_selector 'h1', text: sprint_sale.meid
    end

    it 'has the sale date' do
      expect(page).to have_content sprint_sale.sale_date.strftime('%m/%d/%Y')
    end
    
    it 'has the creation date' do
      expect(page).to have_content sprint_sale.created_at.strftime('%m/%d/%Y %-l:%M%P')
    end

    it 'has the seller name' do
      expect(page).to have_selector 'a', text: rep.display_name
    end
    
    it 'has the location' do
      expect(page).to have_selector 'a', text: sprint_sale.location.name
    end

    it 'has the location area name' do
      expect(page).to have_content area_one.name
    end

    it 'has the mobile phone number' do
      phone = sprint_sale.mobile_phone
      expect(page).to have_selector 'a', text: "(#{phone[0..2]}) #{phone[3..5]}-#{phone[6..9]}"
    end

    it 'has the meid' do
      expect(page).to have_content sprint_sale.meid
    end

    it 'has the carrier' do
      expect(page).to have_content sprint_sale.sprint_carrier.name
    end

    it 'has the handset name' do
      expect(page).to have_content sprint_sale.sprint_handset.name
    end

    it 'has the rate plan' do
      expect(page).to have_content sprint_sale.sprint_rate_plan.name
    end

    it 'has whether or not the phone was activated in the store' do
      expect(page).to have_content 'Activated in store?:'
    end

    it 'has the reason not activated in the store' do
      expect(page).to have_content 'Balls'
    end

    it 'has the number of accessories' do
      expect(page).to have_content 'Number of accessories: 1'
    end

    it 'shows international connect information' do
      expect(page).to have_content "Int'l. connect: N/A"
    end

    it 'shows whether insurance was purchased' do
      expect(page).to have_content 'Insurance?:'
    end

    it 'shows the top-up card amount' do
      expect(page).to have_content 'Top-Up card amount: N/A'
    end
  end
end