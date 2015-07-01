# == Schema Information
#
# Table name: directv_customers
#
#  id                               :integer          not null, primary key
#  first_name                       :string           not null
#  last_name                        :string           not null
#  mobile_phone                     :string
#  other_phone                      :string
#  person_id                        :integer
#  comments                         :text
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  location_id                      :integer
#  directv_lead_dismissal_reason_id :integer
#  dismissal_comment                :text
#

require 'rails_helper'

describe DirecTVCustomer do
  subject { build :directv_customer }

  it 'is valid with correct attributes' do
    expect(subject).to be_valid
  end

  it 'requires a location' do
    subject.location = nil
    expect(subject).not_to be_valid
  end

  it 'returns a full name' do
    expect(subject.name).to eq(subject.first_name + ' ' + subject.last_name)
  end

  context 'uniqueness of mobile phone' do
    let!(:directv_customer) { create :directv_customer, mobile_phone: '1234567890' }

    subject { build :directv_customer, mobile_phone: '1234567890' }

    it 'validates that the mobile phone is unique' do
      expect(subject).not_to be_valid
    end
  end

  context 'manageable scope' do
    let(:directv_manager) { create :directv_manager }
    let(:directv_employee) { create :directv_employee }
    let(:other_directv_employee) { create :directv_employee, email: 'test2@cc.salesmakersinc.com' }

    let!(:directv_area) { create :area, person_areas: [manager_person_area,
                                                       employee_person_area,
                                                       other_employee_person_area] }
    let(:manager_person_area) { create :person_area, person: directv_manager, manages: true }
    let(:employee_person_area) { create :person_area, person: directv_employee, manages: false }
    let(:other_employee_person_area) { create :person_area, person: other_directv_employee, manages: false }

    let!(:directv_employee_customer) { create :directv_customer, person: directv_employee }
    let!(:directv_manager_customer) { create :directv_customer, person: directv_manager }
    let!(:other_directv_employee_customer) { create :directv_customer, person: other_directv_employee }

    it 'allows managers to manage their employees customers' do
      manageable = DirecTVCustomer.manageable(directv_manager)
      expect(manageable).to include(directv_employee_customer)
      expect(manageable).to include(other_directv_employee_customer)
    end


    it 'does not allow an employee to manage another employees customers ' do
      manageable = DirecTVCustomer.manageable(directv_employee)
      expect(manageable).not_to include(other_directv_employee_customer)
    end
    it 'does not allow an employee to manage their supervisors customers' do
      manageable = DirecTVCustomer.manageable(directv_employee)
      expect(manageable).not_to include(directv_manager_customer)
      manageable = DirecTVCustomer.manageable(other_directv_employee)
      expect(manageable).not_to include(directv_manager_customer)
    end

    it 'allows an employee to manage their own customers' do
      manageable = DirecTVCustomer.manageable(directv_employee)
      expect(manageable).to include(directv_employee_customer)
      manageable = DirecTVCustomer.manageable(other_directv_employee)
      expect(manageable).to include(other_directv_employee_customer)
      manageable = DirecTVCustomer.manageable(directv_manager)
      expect(manageable).to include(directv_manager_customer)
    end
  end
end
