require 'rails_helper'

describe 'Inventory Reclaim page' do
  let(:person1) { create :person, display_name: 'person1', active: true }
  let(:person2) { create :person, display_name: 'person2', active: true }
  let(:person3) { create :person, display_name: 'person3', active: false }
  let(:person4) { create :person, display_name: 'person4', active: false }
  let(:person5) { create :person, display_name: 'person5' }
  let(:manager) { create :person, position: position, display_name: 'manager' }

  let!(:person1_pa) { create :person_area, person: person1, area: area }
  let!(:person2_pa) { create :person_area, person: person2, area: area }
  let!(:person3_pa) { create :person_area, person: person3, area: area }
  let!(:person4_pa) { create :person_area, person: person4, area: area }
  let!(:person5_pa) { create :person_area, person: person5 }
  let!(:manager_pa) { create :person_area, person: manager, area: area, manages: true }

  let(:area) { create :area, name: 'area1' }

  let(:vonage_device1) { create :vonage_device, person: person1, mac_id: '723556789abc' }
  let(:vonage_device2) { create :vonage_device, person: person1, mac_id: '223456789abc' }
  let(:vonage_device3) { create :vonage_device, person: person3, mac_id: '323456789abc' }

  let!(:vonage_transfer1) { create :vonage_transfer, to_person: person1, vonage_device: vonage_device1, accepted: true }
  let!(:vonage_transfer2) { create :vonage_transfer, to_person: person1, vonage_device: vonage_device2, accepted: false, rejected: false }
  let!(:vonage_transfer3) { create :vonage_transfer, to_person: person3, vonage_device: vonage_device3, accepted: true }

  let(:position) { create :position, permissions: [permission_create, permission_reclaim] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_create) { Permission.new key: 'vonage_device_create',
                                           permission_group: permission_group,
                                           description: 'Test Description' }
  let(:permission_group_reclaim) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_reclaim) { Permission.new key: 'vonage_device_reclaim',
                                            permission_group: permission_group_reclaim,
                                            description: 'Test Description' }

  context 'for unauthorized users' do
    let(:unauth_person) { create :person }

    it 'shows that you are not authorized page' do
      CASClient::Frameworks::Rails::Filter.fake(unauth_person.email)
      visit reclaim_vonage_devices_path
      expect(page).to have_content('Your access does not allow you to view this page')
    end
  end

  context 'for authorized users' do
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(manager.email)
      visit reclaim_vonage_devices_path
    end
    it 'shows the Vonage Reclaiming page' do
      expect(page).to have_content('Vonage Reclaiming')
    end

    describe 'Reclaiming Page' do
      it 'has a dropdown of active people with inventory' do
        expect(page).to have_content('Select Employee')
      end
      it 'Shows inactive people with inventory and marks them as inactive' do
        within('#employee_selection') do
          expect(page).to have_content(person3.display_name + ' - TERMINATED')
        end
      end
      it 'Shows active people with inventory' do
        within('#employee_selection') do
          expect(page).to have_content(person1.display_name)
        end
      end
      it 'Does not show active people without inventory' do
        within('#employee_selection') do
          expect(page).not_to have_content(person2.display_name)
        end
      end
      it 'Does not show inactive people without inventory' do
        within('#employee_selection') do
          expect(page).not_to have_content(person4.display_name)
        end
      end

      it 'Does not show people not managed by current person' do
        within('#employee_selection') do
          expect(page).not_to have_content(person5.display_name)
        end
      end

      it 'redirects you to the employee_reclaim page and displays the correct error message' do
        select person1.display_name, from: 'Select Employee'
        click_on "View"
        click_on "Reclaim"
        expect(current_path).to eq(employees_reclaim_vonage_devices_path)
        expect(page).to have_content('You must select a device to reclaim.')
      end

      context 'selecting a person' do
        it 'shows inventory accepted from active people' do
          select person1.display_name, from: 'Select Employee'
          click_on "View"
          expect(page).to have_content(vonage_device1.mac_id)
        end
        it 'shows inventory not accepted and not rejected from active people' do
          select person1.display_name, from: 'Select Employee'
          click_on "View"
          expect(page).to have_content(vonage_device2.mac_id)
        end
        it 'shows inventory accepted by inactive people' do
          select person3.display_name, from: 'Select Employee'
          click_on "View"
          expect(page).to have_content(vonage_device3.mac_id)
        end
      end
    end

    describe 'reclaiming inventory' do
      before(:each) do
        select person1.display_name, from: 'Select Employee'
        click_on 'View'
      end

      it 'successful when reclaiming one piece of inventory' do
        check 'vonage_reclaim0'
        click_on 'Reclaim'
        vonage_device1.reload
        expect(vonage_device1.person).to eq(manager)
      end
      it 'successful when reclaiming multiple pieces of inventory' do
        check 'vonage_reclaim0'
        check 'vonage_reclaim1'
        click_on 'Reclaim'
        vonage_device1.reload
        vonage_device2.reload
        expect(vonage_device1.person).to eq(manager)
        expect(vonage_device2.person).to eq(manager)
      end

      it 'redirects to root when successful' do
        check 'vonage_reclaim0'
        check 'vonage_reclaim1'
        click_on 'Reclaim'
        expect(current_path).to eq(new_vonage_sale_path)
      end
      #     it 'creates a log entry for every device reclaimed' do
      #       check 'vonage_reclaim0', from: :device_selection
      #       check 'vonage_reclaim1', from: :device_selection
      #       click_on 'Reclaim'
      #       expect(LogEntry.count).to eq(2)
      # end
    end
  end
end

