require 'rails_helper'

describe 'Vonage sales actions' do
  let!(:vonage_mac_prefix) { create :vonage_mac_prefix }
  let(:manager) { create :person, position: position }
  let(:rep) { create :person, position: position }
  let(:manager_person_area) { create :person_area, area: area_one, manages: true }
  let(:area_one) { create :area, project: vonage_retail }
  let(:vonage_retail) { create :project, name: 'Vonage Retail' }
  let(:other_project_area) { create :area, project: other_project }
  let(:other_project) { create :project, name: 'Sprint Retail' }
  let(:rep_person_area) { create :person_area, area: area_one }
  let(:position) { create :position, permissions: [index_permission] }
  let(:index_permission) { create :permission, key: 'vonage_sale_index' }


  context 'when viewing the index' do
    let(:gift_card_override) { create :gift_card_override }
    let!(:rep_vonage_sale) { create :vonage_sale, person: rep, vested: true, gift_card_number: gift_card_override.override_card_number }
    let(:rep_from_another_area) { create :person }
    let!(:rep_from_another_area_person_area) { create :person_area, area: area_two }
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
    end

    describe 'as someone with all field visibility' do
    end
  end
end