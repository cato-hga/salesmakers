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


  describe '#name' do
    it 'should return the display name as name' do
      expect(person.name).to eq(person.display_name)
    end
  end

  describe '#termination_date_invalid?' do
    it 'should return true if (what?)'
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
end
