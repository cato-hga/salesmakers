# == Schema Information
#
# Table name: prescreen_answers
#
#  id                           :integer          not null, primary key
#  candidate_id                 :integer          not null
#  worked_for_salesmakers       :boolean          default(FALSE), not null
#  of_age_to_work               :boolean          default(FALSE), not null
#  eligible_smart_phone         :boolean          default(FALSE), not null
#  can_work_weekends            :boolean          default(FALSE), not null
#  reliable_transportation      :boolean          default(FALSE), not null
#  ok_to_screen                 :boolean          default(FALSE), not null
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  worked_for_sprint            :boolean          default(FALSE), not null
#  high_school_diploma          :boolean          default(FALSE), not null
#  visible_tattoos              :boolean          default(FALSE), not null
#  worked_for_radioshack        :boolean          default(FALSE), not null
#  former_employment_date_start :date
#  former_employment_date_end   :date
#  store_number_city_state      :string
#

require 'rails_helper'

describe PrescreenAnswer do

  let(:answer) { build :prescreen_answer }
  describe 'validations' do
    it 'requires a candidate' do
      answer.candidate_id = nil
      expect(answer).not_to be_valid
    end
    it 'requires an answer to all questions except "has not worked for SalesMakers"' do
      #answer.worked_for_salesmakers = nil
      #expect(answer).not_to be_valid
      answer.of_age_to_work = nil
      expect(answer).not_to be_valid
      answer.eligible_smart_phone = nil
      expect(answer).not_to be_valid
      answer.can_work_weekends = nil
      expect(answer).not_to be_valid
      answer.reliable_transportation = nil
      expect(answer).not_to be_valid
      answer.high_school_diploma = nil
      expect(answer).not_to be_valid
      answer.worked_for_sprint = nil
      expect(answer).not_to be_valid
      answer.ok_to_screen = nil
      expect(answer).not_to be_valid
      answer.visible_tattoos = nil
      expect(answer).not_to be_valid
    end
  end
end
