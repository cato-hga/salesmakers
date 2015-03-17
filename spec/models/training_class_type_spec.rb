require 'rails_helper'

RSpec.describe TrainingClassType, :type => :model do

  describe 'validations' do
    let(:type) { build :training_class_type }
    it 'requires a project' do
      type.project_id = nil
      expect(type).not_to be_valid
    end
    it 'requires a name' do
      type.name = nil
      expect(type).not_to be_valid
    end
  end
end
