# == Schema Information
#
# Table name: people
#
#  id                                   :integer          not null, primary key
#  first_name                           :string           not null
#  last_name                            :string           not null
#  display_name                         :string           not null
#  email                                :string           not null
#  personal_email                       :string
#  position_id                          :integer
#  created_at                           :datetime
#  updated_at                           :datetime
#  active                               :boolean          default(TRUE), not null
#  connect_user_id                      :string
#  supervisor_id                        :integer
#  office_phone                         :string
#  mobile_phone                         :string
#  home_phone                           :string
#  eid                                  :integer
#  groupme_access_token                 :string
#  groupme_token_updated                :datetime
#  group_me_user_id                     :string
#  last_seen                            :datetime
#  changelog_entry_id                   :integer
#  vonage_tablet_approval_status        :integer          default(0), not null
#  passed_asset_hours_requirement       :boolean          default(FALSE), not null
#  sprint_prepaid_asset_approval_status :integer          default(0), not null
#
require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe Person, :type => :model do
  let(:person) { create :it_tech_person }
  it do
    should ensure_length_of(:first_name).is_at_least(2)
    should ensure_length_of(:last_name).is_at_least(2)
    should ensure_length_of(:display_name).is_at_least(5)
    should allow_value('a@b.com').for(:email)
    should allow_value('a@b.com').for(:personal_email)
    should_not allow_value('a@b', 'ab.com').for(:email)
    should_not allow_value('a@b', 'ab.com').for(:personal_email)
    should allow_value('2134567890').for(:mobile_phone)
    should allow_value('2134567890').for(:office_phone)
    should allow_value('2134567890').for(:home_phone)
    should_not allow_value('1234567890', '24254', '0123456789').for(:mobile_phone)
    should_not allow_value('1234567890', '24254', '0123456789').for(:office_phone)
    should_not allow_value('1234567890', '24254', '0123456789').for(:home_phone)
  end

  it 'responds to update_position_from_connect?' do
    expect(person).to respond_to :update_position_from_connect?
  end

  describe 'uniqueness validations' do
    let(:second_person) { create :person }

    it 'should allow multiple null values for connect_user_id' do
      person.connect_user_id = nil
      person.save
      second_person.connect_user_id = nil
      second_person.save
      expect(second_person).to be_valid
    end

    it 'should not allow duplicate not null values for connect_user_id' do
      person.connect_user_id = 123
      person.save
      second_person.connect_user_id = 123
      second_person.save
      expect(second_person).not_to be_valid
    end

    it 'should not allow duplicate values for email' do
      person.email = 'test@test.com'
      person.save
      second_person.email = 'test@test.com'
      second_person.save
      expect(second_person).not_to be_valid
    end

    it 'should allow duplicate null values for personal email' do
      person.personal_email = nil
      person.save
      second_person.personal_email = nil
      second_person.save
      expect(second_person).to be_valid
    end

    it 'should allow duplicate values for first name and last name (combined)' do
      person.first_name = 'Test'
      person.last_name = 'Case'
      person.save
      second_person.first_name = 'Test'
      second_person.last_name = 'Case'
      second_person.save
      expect(second_person).to be_valid
    end

    it 'should not allow duplicate values for first name, last name, and a phone number (combined)' do
      person.first_name = 'Test'
      person.last_name = 'Case'
      person.mobile_phone = '8005551111'
      person.save
      second_person.first_name = 'Test'
      second_person.last_name = 'Case'
      second_person.mobile_phone = '8005551111'
      second_person.save
      expect(second_person).to be_valid
    end
  end

  describe 'phone number presence validation' do

    let(:person) { create :person }

    subject { person }

    it 'should require at least one phone number' do
      person.mobile_phone = nil
      person.office_phone = nil
      person.home_phone = nil
      expect(subject).not_to be_valid
      person.office_phone = '7274985180'
      expect(subject).to be_valid
      person.office_phone = nil
      person.mobile_phone = '5555555555'
      expect(subject).to be_valid
      person.mobile_phone = nil
      person.home_phone = '5565565566'
      expect(subject).to be_valid
    end

    it 'should clean the phone numbers' do
      person.mobile_phone = '716-415-8130'
      person.save
      expect(person.mobile_phone).to eq('7164158130')
    end

    it 'should change empty strings in phone numbers to nil' do
      person.office_phone = ''
      person.save
      expect(person.office_phone).to eq(nil)
    end

  end

  describe '#team_members' do
    let(:person) { create :person }
    it 'should return team members' do
      expect(person.team_members).to_not be_nil
    end

    it 'should return department members' do
      expect(person.department_members).to_not be_nil
    end

    it 'should return all HQ members if person has all HQ visibility' do
      person.position.hq = true
      expect(Person.all_hq_members).to_not be_nil
    end
  end

  describe '#managed_team_members' do
    let(:manager) { create :person }
    let(:employee) { create :person, email: 'employee@test.com' }
    let(:non_managed_employee) { create :person, email: 'other@test.com' }
    let(:area) { create :area }
    let(:non_managed_area) { create :area }
    let!(:person_area) { create :person_area, area: area, person: manager, manages: true }
    let!(:employee_person_area) { create :person_area, area: area, person: employee }
    let!(:non_managed_employee_person_area) { create :person_area, area: non_managed_area, person: non_managed_employee }
    it 'returns self if manager' do
      expect(manager.managed_team_members).to include(manager)
    end
    it 'returns employees of a area that a manager manages' do
      expect(manager.managed_team_members).to include(employee)
    end
    it 'does not return employees outside of a managers managed areas' do
      expect(manager.managed_team_members).not_to include(non_managed_employee)
    end
    it 'returns nothing if an employee does not have a person area they manage' do
      expect(employee.managed_team_members.count).to eq(0)
    end
  end

  describe 'visible scope' do
    let(:foo_project) { create :project, name: 'Project Foo' }
    let(:bar_project) { create :project, name: 'Project Bar' }
    let(:foo_root) {
      create :area,
             name: 'Foo Root Area',
             project: foo_project
    }
    let(:bar_root) {
      create :area,
             name: 'Bar Root Area',
             project: bar_project
    }
    let(:foo_root_child) {
      create :area,
             name: 'Foo Root Child',
             project: foo_project
    }
    let(:bar_root_child) {
      create :area,
             name: 'Bar Root Child',
             project: bar_project
    }
    let(:foo_root_child_child) {
      create :area,
             name: 'Foo Root Child Child',
             project: foo_project
    }
    let(:bar_root_child_child) {
      create :area,
             name: 'Bar Root Child Child',
             project: bar_project
    }
    let(:hq_department) {
      create :department,
             name: 'Headquarters'
    }
    let(:other_hq_department) {
      create :department,
             name: 'Other Headquarters'
    }
    let(:field_department) {
      create :department,
             name: 'Field'
    }
    let(:field_position) {
      create :position,
             hq: false,
             all_field_visibility: false,
             all_corporate_visibility: false,
             department: field_department
    }
    let(:hq_position) {
      create :position,
             hq: true,
             field: false,
             all_field_visibility: false,
             all_corporate_visibility: false,
             department: hq_department
    }
    let(:other_hq_position) {
      create :position,
             hq: true,
             field: false,
             all_field_visibility: false,
             all_corporate_visibility: false,
             department: other_hq_department
    }
    let(:all_field_position) {
      create :position,
             hq: false,
             all_field_visibility: true,
             all_corporate_visibility: false,
             department: field_department
    }
    let(:all_corporate_position) {
      create :position,
             hq: false,
             field: false,
             all_field_visibility: false,
             all_corporate_visibility: true,
             department: hq_department
    }
    let(:everything_position) {
      create :position,
             hq: true,
             field: true,
             all_field_visibility: true,
             all_corporate_visibility: true,
             department: hq_department
    }
    let(:foo_root_manager) {
      create :person,
             position: field_position
    }
    let!(:foo_root_manager_person_area) {
      create :person_area,
             person: foo_root_manager,
             area: foo_root,
             manages: true
    }
    let(:bar_root_manager) {
      create :person,
             position: field_position
    }
    let!(:bar_root_manager_person_area) {
      create :person_area,
             person: bar_root_manager,
             area: bar_root,
             manages: true
    }
    let(:foo_root_child_manager) {
      create :person,
             position: field_position,
             supervisor: foo_root_manager
    }
    let!(:foo_root_child_manager_person_area) {
      create :person_area,
             person: foo_root_child_manager,
             area: foo_root_child,
             manages: true
    }
    let(:bar_root_child_manager) {
      create :person,
             position: field_position,
             supervisor: bar_root_manager
    }
    let!(:bar_root_child_manager_person_area) {
      create :person_area,
             person: bar_root_child_manager,
             area: bar_root_child,
             manages: true
    }
    let(:foo_root_child_child_manager) {
      create :person,
             position: field_position,
             supervisor: foo_root_child_manager
    }
    let!(:foo_root_child_child_manager_person_area) {
      create :person_area,
             person: foo_root_child_child_manager,
             area: foo_root_child_child,
             manages: true
    }
    let(:bar_root_child_child_manager) {
      create :person,
             position: field_position,
             supervisor: bar_root_child_manager
    }
    let!(:bar_root_child_child_manager_person_area) {
      create :person_area,
             person: bar_root_child_child_manager,
             area: bar_root_child_child,
             manages: true
    }
    let(:foo_rep) {
      create :person,
             supervisor: foo_root_child_child_manager,
             position: field_position
    }
    let!(:foo_rep_person_area) {
      create :person_area,
             person: foo_rep,
             area: foo_root_child_child
    }
    let(:bar_rep) {
      create :person,
             supervisor: bar_root_child_child_manager,
             position: field_position
    }
    let!(:bar_rep_person_area) {
      create :person_area,
             person: bar_rep,
             area: bar_root_child_child
    }
    let!(:hq_manager) {
      create :person,
             position: hq_position
    }
    let!(:hq_employee) {
      create :person,
             supervisor: hq_manager,
             position: hq_position
    }
    let!(:other_hq_employee) {
      create :person,
             position: other_hq_position
    }
    let!(:all_field_employee) {
      create :person,
             position: all_field_position
    }
    let!(:all_corporate_employee) {
      create :person,
             position: all_corporate_position
    }
    let!(:everything_employee) {
      create :person,
             position: everything_position
    }

    before do
      foo_root_child.update parent: foo_root
      bar_root_child.update parent: bar_root
      foo_root_child_child.update parent: foo_root_child
      bar_root_child_child.update parent: bar_root_child
    end

    it 'returns no people if a person is not given as a parameter' do
      expect(Person.visible).to be_empty
    end

    context 'as a rep' do
      let!(:visible) { Person.visible(foo_rep) }

      it 'has the proper count' do
        expect(visible.count).to eq(2)
      end

      it 'includes people that should be visible' do
        expect(visible).to include(foo_root_child_child_manager)
        expect(visible).to include(foo_rep)
      end

      it 'excludes people that should not be visible' do
        expect(visible).not_to include(foo_root_manager)
        expect(visible).not_to include(foo_root_child_manager)
        expect(visible).not_to include(bar_root_manager)
        expect(visible).not_to include(bar_root_child_manager)
        expect(visible).not_to include(bar_root_child_child_manager)
        expect(visible).not_to include(bar_rep)
        expect(visible).not_to include(hq_manager)
        expect(visible).not_to include(hq_employee)
        expect(visible).not_to include(other_hq_employee)
        expect(visible).not_to include(all_field_employee)
        expect(visible).not_to include(all_corporate_employee)
        expect(visible).not_to include(everything_employee)
      end
    end

    context 'as a root-child-child manager' do
      let!(:visible) { Person.visible(foo_root_child_child_manager) }

      it 'has the proper count' do
        expect(visible.count).to eq(2)
      end

      it 'includes people that should be visible' do
        expect(visible).to include(foo_root_child_child_manager)
        expect(visible).to include(foo_rep)
      end

      it 'excludes people that should not be visible' do
        expect(visible).not_to include(foo_root_manager)
        expect(visible).not_to include(foo_root_child_manager)
        expect(visible).not_to include(bar_root_manager)
        expect(visible).not_to include(bar_root_child_manager)
        expect(visible).not_to include(bar_root_child_child_manager)
        expect(visible).not_to include(bar_rep)
        expect(visible).not_to include(hq_manager)
        expect(visible).not_to include(hq_employee)
        expect(visible).not_to include(other_hq_employee)
        expect(visible).not_to include(all_field_employee)
        expect(visible).not_to include(all_corporate_employee)
        expect(visible).not_to include(everything_employee)
      end
    end

    context 'as a root-child manager' do
      let!(:visible) { Person.visible(foo_root_child_manager) }

      it 'has the proper count' do
        expect(visible.count).to eq(3)
      end

      it 'includes people that should be visible' do
        expect(visible).to include(foo_root_child_manager)
        expect(visible).to include(foo_root_child_child_manager)
        expect(visible).to include(foo_rep)
      end

      it 'excludes people that should not be visible' do
        expect(visible).not_to include(foo_root_manager)
        expect(visible).not_to include(bar_root_manager)
        expect(visible).not_to include(bar_root_child_manager)
        expect(visible).not_to include(bar_root_child_child_manager)
        expect(visible).not_to include(bar_rep)
        expect(visible).not_to include(hq_manager)
        expect(visible).not_to include(hq_employee)
        expect(visible).not_to include(other_hq_employee)
        expect(visible).not_to include(all_field_employee)
        expect(visible).not_to include(all_corporate_employee)
        expect(visible).not_to include(everything_employee)
      end
    end

    context 'as a root manager' do
      let!(:visible) { Person.visible(foo_root_manager) }

      it 'has the proper count' do
        expect(visible.count).to eq(4)
      end

      it 'includes people that should be visible' do
        expect(visible).to include(foo_root_manager)
        expect(visible).to include(foo_root_child_manager)
        expect(visible).to include(foo_root_child_child_manager)
        expect(visible).to include(foo_rep)
      end

      it 'excludes people that should not be visible' do
        expect(visible).not_to include(bar_root_manager)
        expect(visible).not_to include(bar_root_child_manager)
        expect(visible).not_to include(bar_root_child_child_manager)
        expect(visible).not_to include(bar_rep)
        expect(visible).not_to include(hq_manager)
        expect(visible).not_to include(hq_employee)
        expect(visible).not_to include(other_hq_employee)
        expect(visible).not_to include(all_field_employee)
        expect(visible).not_to include(all_corporate_employee)
        expect(visible).not_to include(everything_employee)
      end
    end

    context 'as an HQ manager' do
      let!(:visible) { Person.visible(hq_manager) }

      it 'has the proper count' do
        expect(visible.count).to eq(4)
      end

      it 'includes people that should be visible' do
        expect(visible).to include(hq_manager)
        expect(visible).to include(hq_employee)
        expect(visible).to include(all_corporate_employee)
        expect(visible).to include(everything_employee)
      end

      it 'excludes people that should not be visible' do
        expect(visible).not_to include(foo_root_manager)
        expect(visible).not_to include(foo_root_child_manager)
        expect(visible).not_to include(foo_root_child_child_manager)
        expect(visible).not_to include(foo_rep)
        expect(visible).not_to include(bar_root_manager)
        expect(visible).not_to include(bar_root_child_manager)
        expect(visible).not_to include(bar_root_child_child_manager)
        expect(visible).not_to include(bar_rep)
        expect(visible).not_to include(other_hq_employee)
        expect(visible).not_to include(all_field_employee)
      end
    end

    context 'as an HQ employee' do
      let!(:visible) { Person.visible(hq_employee) }

      it 'has the proper count' do
        expect(visible.count).to eq(4)
      end

      it 'includes people that should be visible' do
        expect(visible).to include(hq_manager)
        expect(visible).to include(hq_employee)
        expect(visible).to include(all_corporate_employee)
        expect(visible).to include(everything_employee)
      end

      it 'excludes people that should not be visible' do
        expect(visible).not_to include(foo_root_manager)
        expect(visible).not_to include(foo_root_child_manager)
        expect(visible).not_to include(foo_root_child_child_manager)
        expect(visible).not_to include(foo_rep)
        expect(visible).not_to include(bar_root_manager)
        expect(visible).not_to include(bar_root_child_manager)
        expect(visible).not_to include(bar_root_child_child_manager)
        expect(visible).not_to include(bar_rep)
        expect(visible).not_to include(other_hq_employee)
        expect(visible).not_to include(all_field_employee)
      end
    end

    context 'as an other HQ employee' do
      let!(:visible) { Person.visible(other_hq_employee) }

      it 'has the proper count' do
        expect(visible.count).to eq(1)
      end

      it 'includes people that should be visible' do
        expect(visible).to include(other_hq_employee)
      end

      it 'excludes people that should not be visible' do
        expect(visible).not_to include(foo_root_manager)
        expect(visible).not_to include(foo_root_child_manager)
        expect(visible).not_to include(foo_root_child_child_manager)
        expect(visible).not_to include(foo_rep)
        expect(visible).not_to include(bar_root_manager)
        expect(visible).not_to include(bar_root_child_manager)
        expect(visible).not_to include(bar_root_child_child_manager)
        expect(visible).not_to include(bar_rep)
        expect(visible).not_to include(hq_manager)
        expect(visible).not_to include(hq_employee)
        expect(visible).not_to include(all_corporate_employee)
        expect(visible).not_to include(everything_employee)
        expect(visible).not_to include(all_field_employee)
      end
    end

    context 'as an all-field-visibility employee' do
      let!(:visible) { Person.visible(all_field_employee) }

      it 'has the proper count' do
        expect(visible.count).to eq(10)
      end

      it 'includes people that should be visible' do
        expect(visible).to include(foo_root_manager)
        expect(visible).to include(foo_root_child_manager)
        expect(visible).to include(foo_root_child_child_manager)
        expect(visible).to include(foo_rep)
        expect(visible).to include(bar_root_manager)
        expect(visible).to include(bar_root_child_manager)
        expect(visible).to include(bar_root_child_child_manager)
        expect(visible).to include(bar_rep)
        expect(visible).to include(all_field_employee)
        expect(visible).to include(everything_employee)
      end

      it 'excludes people that should not be visible' do
        expect(visible).not_to include(hq_manager)
        expect(visible).not_to include(hq_employee)
        expect(visible).not_to include(other_hq_employee)
        expect(visible).not_to include(all_corporate_employee)
      end
    end

    context 'as an all-corporate-visibility employee' do
      let!(:visible) { Person.visible(all_corporate_employee) }

      it 'has the proper count' do
        expect(visible.count).to eq(4)
      end

      it 'includes people that should be visible' do
        expect(visible).to include(hq_manager)
        expect(visible).to include(hq_employee)
        expect(visible).to include(other_hq_employee)
        expect(visible).to include(everything_employee)
      end

      it 'excludes people that should not be visible' do
        expect(visible).not_to include(foo_root_manager)
        expect(visible).not_to include(foo_root_child_manager)
        expect(visible).not_to include(foo_root_child_child_manager)
        expect(visible).not_to include(foo_rep)
        expect(visible).not_to include(bar_root_manager)
        expect(visible).not_to include(bar_root_child_manager)
        expect(visible).not_to include(bar_root_child_child_manager)
        expect(visible).not_to include(bar_rep)
        expect(visible).not_to include(all_corporate_employee)
        expect(visible).not_to include(all_field_employee)
      end
    end

    context 'as an everything-is-visible employee' do
      let!(:visible) { Person.visible(everything_employee) }

      it 'has the proper count' do
        expect(visible.count).to eq(14)
      end

      it 'includes everyone' do
        expect(visible).to include(foo_root_manager)
        expect(visible).to include(foo_root_child_manager)
        expect(visible).to include(foo_root_child_child_manager)
        expect(visible).to include(foo_rep)
        expect(visible).to include(bar_root_manager)
        expect(visible).to include(bar_root_child_manager)
        expect(visible).to include(bar_root_child_child_manager)
        expect(visible).to include(bar_rep)
        expect(visible).to include(hq_manager)
        expect(visible).to include(hq_employee)
        expect(visible).to include(other_hq_employee)
        expect(visible).to include(everything_employee)
        expect(visible).to include(all_corporate_employee)
        expect(visible).to include(all_field_employee)
      end
    end
  end

  describe '#name' do
    it 'should return the display name as name' do
      expect(person.name).to eq(person.display_name)
    end
  end

  describe '#terminated?' do
    let!(:employment) { create :employment, person: person, end: Time.now }
    it 'should return true if the first employee record has an end' do
      expect(person.terminated?).to be_truthy
    end
  end

  describe '#locations' do
    let(:person_one) { create :person }
    let(:person_two) { create :person }
    let(:area_one) { create :area }
    let(:area_two) { create :area, name: 'Area Two' }
    let(:location_one) { create :location }
    let(:location_two) { create :location }
    let!(:location_area_one) {
      create :location_area,
             location: location_one,
             area: area_one
    }
    let!(:location_area_two) {
      create :location_area,
             location: location_two,
             area: area_two
    }
    let!(:person_area_one) {
      create :person_area,
             person: person_one,
             area: area_one
    }
    let!(:person_area_two) {
      create :person_area,
             person: person_two,
             area: area_two
    }

    before do
      area_two.update parent: area_one
    end

    it 'should return one location for base level' do
      expect(person_two.locations.count).to eq(1)
    end

    it 'should return location tree for non-base level' do
      expect(person_one.locations.count).to eq(2)
    end
  end

  describe 'separation', :vcr do
    let(:to_separate) { create :person }
    let!(:candidate) { create :candidate, person: to_separate, status: :onboarded, location_area: location_area }
    let(:location_area) { create :location_area }

    subject { to_separate.separate }

    it 'deactivates the employee' do
      expect {
        subject
        to_separate.reload
      }.to change(to_separate, :active).from(true).to(false)
    end

    it 'changes a location_area current_head_count' do
      location_area.reload
      expect {
        subject
        location_area.reload
      }.to change(location_area, :current_head_count).from(1).to(0)
    end
  end

  describe '.skip_for_assets?' do
    let(:person) { create :person, passed_asset_hours_requirement: false, vonage_tablet_approval_status: 0 }
    let!(:person_area) { create :person_area, area: area, person: person }
    let(:area) { create :area, project: von_project }
    let(:von_project) { create :project, name: 'Vonage Retail' }
    let(:other_project) { create :project, name: 'Other Retail' }
    let(:sprint_prepaid) { create :project, name: 'Sprint Retail' }
    it 'returns true if the person has passed asset hours requirement' do
      expect(person.skip_for_assets?).to eq(false)
      person.update passed_asset_hours_requirement: true
      person.reload
      expect(person.skip_for_assets?).to eq(true)
    end

    it 'returns true if the person has been denied for an asset' do
      expect(person.skip_for_assets?).to eq(false)
      person.update vonage_tablet_approval_status: :denied
      person.reload
      expect(person.skip_for_assets?).to eq(true)
    end

    it 'returns true if the person has been approved for an asset' do
      expect(person.skip_for_assets?).to eq(false)
      person.update vonage_tablet_approval_status: :approved
      person.reload
      expect(person.skip_for_assets?).to eq(true)
    end

    it 'returns true if the person is not a Sprint Prepaid or Vonage employee' do
      expect(person.skip_for_assets?).to eq(false)
      area.update project: sprint_prepaid
      area.reload
      person_area.reload
      person.reload
      expect(person.skip_for_assets?).to eq(false)
      area.update project: other_project
      area.reload
      person_area.reload
      person.reload
      expect(person.skip_for_assets?).to eq(true)
    end
  end

  describe '.get_supervisors' do
    let(:person) { create :person, display_name: 'Employee' }
    let(:direct_supervisor) { create :person, display_name: 'Supervisor' }
    let(:market_supervisor) { create :person, display_name: 'Market Supervisor' }
    let(:regional_supervisor) { create :person, display_name: 'Regional Supervisor' }
    let(:area) { create :area, parent: market_area }
    let(:market_area) { create :area, parent: regional_area }
    let(:regional_area) { create :area }
    let!(:person_area) { create :person_area, area: area, person: person }
    let!(:supervisor_area) { create :person_area, area: area, person: direct_supervisor, manages: true }
    let!(:market_supervisor_area) { create :person_area, area: market_area, person: market_supervisor, manages: true }
    let!(:regional_supervisor_area) { create :person_area, area: regional_area, person: regional_supervisor, manages: true }

    it 'returns the direct supervisor, if available' do
      person.update supervisor: direct_supervisor
      person.reload
      expect(person.get_supervisors).to eq([direct_supervisor])
    end
    it 'returns the area managers for an employee, if there is not a team supervisor' do
      supervisor_area.update manages: false
      supervisor_area.reload
      expect(person.get_supervisors).to eq([market_supervisor])
    end
    it 'returns the regional managers for an employee if there is not a team or area manager' do
      supervisor_area.update manages: false
      supervisor_area.reload
      market_supervisor_area.update manages: false
      market_supervisor_area.reload
      expect(person.get_supervisors).to eq([regional_supervisor]) #making sure that the market supervisor isn't returned
    end
  end

  describe '#no_tablets_from_collection' do
    let!(:person_with_tablet) { create :person, display_name: 'Tablet' }
    let!(:tablet) { create :device, device_model: tablet_model, person: person_with_tablet }
    let!(:tablet_model) { create :device_model, name: 'GalaxyTab' }
    let!(:person_with_laptop) { create :person, display_name: 'Laptop' }
    let!(:laptop_model) { create :device_model, name: 'Laptop Model' }
    let!(:laptop) { create :device, device_model: laptop_model, person: person_with_laptop }
    let!(:person_without_assets) { create :person, display_name: 'Nothing' }

    it 'returns a list of employees without tablets' do
      collection = [person_without_assets, person_with_tablet, person_with_laptop]
      no_tablets = Person.no_assets_from_collection(collection)
      expect(no_tablets).not_to include(person_with_tablet)
      expect(no_tablets).to include(person_with_laptop)
      expect(no_tablets).to include(person_without_assets)
    end
  end

  describe 'when a person is reactivated and the candidate is inactive' do
    let!(:person) { create :person }
    let!(:candidate) { create :candidate, person: person, active: false }

    it 'should set the candidate to active when person is set to active' do
      expect {
        person.update active: true
        candidate.reload
      }.to change(candidate, :active).from(false).to(true)
    end
  end


end
