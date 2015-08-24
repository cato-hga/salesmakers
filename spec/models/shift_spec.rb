# == Schema Information
#
# Table name: shifts
#
#  id          :integer          not null, primary key
#  person_id   :integer          not null
#  location_id :integer
#  date        :date             not null
#  hours       :decimal(, )      not null
#  break_hours :decimal(, )      default(0.0), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  training    :boolean          default(FALSE), not null
#  project_id  :integer
#

require 'rails_helper'

describe Shift do
  subject { build :shift }

  it 'requires an indiciation of whether or not the shift is a training shift' do
    subject.training = nil
    expect(subject).not_to be_valid
  end
end
