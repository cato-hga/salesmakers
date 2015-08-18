# == Schema Information
#
# Table name: radio_shack_location_schedules
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  active     :boolean          default(TRUE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  monday     :float            default(0.0), not null
#  tuesday    :float            default(0.0), not null
#  wednesday  :float            default(0.0), not null
#  thursday   :float            default(0.0), not null
#  friday     :float            default(0.0), not null
#  saturday   :float            default(0.0), not null
#  sunday     :float            default(0.0), not null
#

require 'rails_helper'

describe RadioShackLocationSchedule do

  describe 'validations' do
    let(:schedule) { build :radio_shack_location_schedule }

    it 'requires an active y/n' do
      schedule.active = nil
      expect(schedule).not_to be_valid
    end
  end

end
