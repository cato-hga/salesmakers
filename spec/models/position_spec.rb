require 'rails_helper'

RSpec.describe Position, :type => :model do

  describe 'Validations' do
    before(:each) do
      @attrs = { name: 'Sales Rep',
                 leadership: false,
                 all_field_visibility: false,
                 all_corporate_visibility: false,
                 department_id: #TODO Create department
      }
      @department = Department.new @attrs
    end

    subject { @department }

    it 'should work with valid parameters' do
      should be_valid
    end
  end
end
