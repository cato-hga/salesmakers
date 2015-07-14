# == Schema Information
#
# Table name: comcast_customers
#
#  id                               :integer          not null, primary key
#  first_name                       :string           not null
#  last_name                        :string           not null
#  mobile_phone                     :string
#  other_phone                      :string
#  person_id                        :integer          not null
#  comments                         :text
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  location_id                      :integer          not null
#  comcast_lead_dismissal_reason_id :integer
#  dismissal_comment                :text
#

require 'rails_helper'

describe ComcastCustomer do
  subject { build :comcast_customer }

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
    let!(:comcast_customer) { create :comcast_customer, mobile_phone: '1234567890' }

    subject { build :comcast_customer, mobile_phone: '1234567890' }

    it 'validates that the mobile phone is unique' do
      expect(subject).not_to be_valid
    end
  end

  context 'manageable scope' do
    let(:comcast_manager) { create :comcast_manager }
    let(:comcast_employee) { create :comcast_employee }
    let(:other_comcast_employee) { create :comcast_employee, email: 'test2@cc.salesmakersinc.com' }

    let!(:comcast_area) { create :area, person_areas: [manager_person_area,
                                                       employee_person_area,
                                                       other_employee_person_area] }
    let(:manager_person_area) { create :person_area, person: comcast_manager, manages: true }
    let(:employee_person_area) { create :person_area, person: comcast_employee, manages: false }
    let(:other_employee_person_area) { create :person_area, person: other_comcast_employee, manages: false }

    let!(:comcast_employee_customer) { create :comcast_customer, person: comcast_employee }
    let!(:comcast_manager_customer) { create :comcast_customer, person: comcast_manager }
    let!(:other_comcast_employee_customer) { create :comcast_customer, person: other_comcast_employee }

    it 'allows managers to manage their employees customers' do
      manageable = ComcastCustomer.manageable(comcast_manager)
      expect(manageable).to include(comcast_employee_customer)
      expect(manageable).to include(other_comcast_employee_customer)
    end

    it 'does not allow an employee to manage another employees customers ' do
      manageable = ComcastCustomer.manageable(comcast_employee)
      expect(manageable).not_to include(other_comcast_employee_customer)
    end
    it 'does not allow an employee to manage their supervisors customers' do
      manageable = ComcastCustomer.manageable(comcast_employee)
      expect(manageable).not_to include(comcast_manager_customer)
      manageable = ComcastCustomer.manageable(other_comcast_employee)
      expect(manageable).not_to include(comcast_manager_customer)
    end

    it 'allows an employee to manage their own customers' do
      manageable = ComcastCustomer.manageable(comcast_employee)
      expect(manageable).to include(comcast_employee_customer)
      manageable = ComcastCustomer.manageable(other_comcast_employee)
      expect(manageable).to include(other_comcast_employee_customer)
      manageable = ComcastCustomer.manageable(comcast_manager)
      expect(manageable).to include(comcast_manager_customer)
    end
  end
end
