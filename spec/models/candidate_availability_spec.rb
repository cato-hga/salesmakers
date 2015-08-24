# == Schema Information
#
# Table name: candidate_availabilities
#
#  id               :integer          not null, primary key
#  monday_first     :boolean          default(FALSE), not null
#  monday_second    :boolean          default(FALSE), not null
#  monday_third     :boolean          default(FALSE), not null
#  tuesday_first    :boolean          default(FALSE), not null
#  tuesday_second   :boolean          default(FALSE), not null
#  tuesday_third    :boolean          default(FALSE), not null
#  wednesday_first  :boolean          default(FALSE), not null
#  wednesday_second :boolean          default(FALSE), not null
#  wednesday_third  :boolean          default(FALSE), not null
#  thursday_first   :boolean          default(FALSE), not null
#  thursday_second  :boolean          default(FALSE), not null
#  thursday_third   :boolean          default(FALSE), not null
#  friday_first     :boolean          default(FALSE), not null
#  friday_second    :boolean          default(FALSE), not null
#  friday_third     :boolean          default(FALSE), not null
#  saturday_first   :boolean          default(FALSE), not null
#  saturday_second  :boolean          default(FALSE), not null
#  saturday_third   :boolean          default(FALSE), not null
#  sunday_first     :boolean          default(FALSE), not null
#  sunday_second    :boolean          default(FALSE), not null
#  sunday_third     :boolean          default(FALSE), not null
#  candidate_id     :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  comment          :text
#

require 'rails_helper'

RSpec.describe CandidateAvailability, :type => :model do

  describe 'validations' do
    let(:available) { build :candidate_availability }

    it 'requires at least one option selected' do
      available.monday_first = false
      available.tuesday_second = false
      expect(available).not_to be_valid
      available.tuesday_first = true
      expect(available).to be_valid
      available.tuesday_first = false
      expect(available).not_to be_valid
    end
  end
end
