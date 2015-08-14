# == Schema Information
#
# Table name: location_areas
#
#  id                        :integer          not null, primary key
#  location_id               :integer          not null
#  area_id                   :integer          not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  current_head_count        :integer          default(0), not null
#  potential_candidate_count :integer          default(0), not null
#  target_head_count         :integer          default(0), not null
#  active                    :boolean          default(TRUE), not null
#  hourly_rate               :float
#  offer_extended_count      :integer          default(0), not null
#  outsourced                :boolean          default(FALSE), not null
#  launch_group              :integer
#  distance_to_cor           :float
#  priority                  :integer
#

require 'rails_helper'

describe LocationArea do
  subject { build :location_area }

  it 'does not allow duplicates' do
    subject.save
    duplicate = subject.dup
    expect(duplicate).not_to be_valid
  end

  it 'responds to launch group number' do
    expect(subject).to respond_to(:launch_group)
  end

  describe '#head_count_full?' do
    let(:hours_at_location_location) { create :location }
    let!(:hours_at_location_location_area) { create :location_area, location: hours_at_location_location, target_head_count: 1 }
    let!(:hours_at_location_candidate) { create :candidate,
                                                location_area: hours_at_location_location_area,
                                                person: hours_at_location_person,
                                                sprint_radio_shack_training_session: hours_at_location_training_session,
                                                updated_at: DateTime.now - 8.days }
    let(:hours_at_location_person) { create :person }
    let(:hours_at_location_shift) { create :shift, person: hours_at_location_person, date: Date.today - 6.days, hours: 8 }
    let!(:second_hours_at_location_shift) { create :shift, person: hours_at_location_person, date: Date.today - 5.days, hours: 8 }
    let(:hours_at_location_training_session) { create :sprint_radio_shack_training_session }

    let(:recent_trainings_location) { create :location }
    let!(:recent_trainings_location_area) { create :location_area, location: recent_trainings_location, target_head_count: 1 }
    let(:recent_trainings_candidate) { create :candidate,
                                              location_area: recent_trainings_location_area,
                                              person: recent_trainings_person,
                                              updated_at: DateTime.now - 8.days }
    let(:recent_trainings_person) { create :person }
    let!(:recent_trainings_shift) { create :shift, person: recent_trainings_person, date: Date.today - 6.days, hours: 8 }
    let(:recent_training_session) { create :sprint_radio_shack_training_session, start_date: Date.today }

    let(:inactive_candidate_location) { create :location }
    let!(:inactive_candidate_location_area) { create :location_area, location: inactive_candidate_location, target_head_count: 1 }
    let!(:inactive_candidate_candidate) { create :candidate,
                                                 location_area: inactive_candidate_location_area,
                                                 person: inactive_candidate_person,
                                                 active: false,
                                                 sprint_radio_shack_training_session: hours_at_location_training_session,
                                                 updated_at: DateTime.now - 8.days }
    let(:inactive_candidate_person) { create :person, active: false }
    let!(:inactive_candidate_shift) { create :shift, person: inactive_candidate_person, date: Date.today - 6.days, hours: 8 }
    let(:paperwork_sent_past_week_location_area) { create :location_area, target_head_count: 1 }
    let(:paperwork_sent_past_week_candidate) { create :candidate, status: :paperwork_sent, location_area: paperwork_sent_past_week_location_area }
    let(:paperwork_sent_past_week_job_offer_detail) { create :job_offer_detail, sent: Date.today - 6.days, candidate: paperwork_sent_past_week_candidate }
    let(:paperwork_sent_since_june_8_location_area) { create :location_area, target_head_count: 1, priority: 1 }
    let(:paperwork_sent_since_june_8_candidate) { create :candidate, status: :paperwork_sent, location_area: paperwork_sent_since_june_8_location_area }
    let(:paperwork_sent_since_june_8_job_offer_detail) { create :job_offer_detail, sent: Date.new(2015, 6, 8), candidate: paperwork_sent_since_june_8_candidate }

    # context 'for hours at a location in the past 7 days' do
    #   it 'counts a candidate if candidate has booked hours at the location within the past 7 days' do
    #     expect(hours_at_location_location_area.head_count_full?).to eq(false)
    #     hours_at_location_shift.update location: hours_at_location_location
    #     expect(hours_at_location_location_area.head_count_full?).to eq(true)
    #   end
    #   it 'does not count candidates twice' do
    #     hours_at_location_shift.update location: hours_at_location_location
    #     second_hours_at_location_shift.update location: hours_at_location_location
    #     expect(hours_at_location_location_area.head_count_full?).to eq(true)
    #     hours_at_location_location_area.update target_head_count: 2
    #     expect(hours_at_location_location_area.head_count_full?).to eq(false)
    #   end
    # end

    # context 'for recent trainings' do
      # it 'counts a candidate if candidate is in the 4/20 to 5/18 trainings, and have booked any hours in the past 7 days (location independent)' do
      #   expect(recent_trainings_location_area.head_count_full?).to eq(false)
      #   recent_training_session.update name: '4/20', start_date: Date.new(2015, 04, 20)
      #   recent_trainings_candidate.update sprint_radio_shack_training_session: recent_training_session, updated_at: DateTime.now - 8.days
      #   expect(recent_trainings_location_area.head_count_full?).to eq(true)
      #   ActiveRecord::Base.record_timestamps = false
      #   recent_training_session.update name: '5/11', start_date: Date.new(2015, 05, 11)
      #   ActiveRecord::Base.record_timestamps = true
      #   expect(recent_trainings_location_area.head_count_full?).to eq(false)
      #   ActiveRecord::Base.record_timestamps = false
      #   recent_training_session.update name: '5/18', start_date: Date.new(2015, 05, 18)
      #   ActiveRecord::Base.record_timestamps = true
      #   expect(recent_trainings_location_area.head_count_full?).to eq(false)
      # end
      # it 'counts a candidate if candidate is in the 5/18 training, with candidate confirmed training session status', pending: 'Still valid?' do
      #   recent_trainings_shift.update person: nil
      #   recent_training_session.update name: '5/18', start_date: Date.new(2015, 05, 18)
      #   expect(recent_trainings_location_area.head_count_full?).to eq(false)
      #   recent_trainings_candidate.update training_session_status: 'candidate_confirmed', updated_at: DateTime.now - 8.days
      #   expect(recent_trainings_location_area.head_count_full?).to eq(false)
      #   recent_trainings_candidate.update sprint_radio_shack_training_session: recent_training_session
      #   expect(recent_trainings_location_area.head_count_full?).to eq(true)
      # end
    # end

    # it 'counts a candidate whose paperwork was sent since 6/08' do
    #   expect(paperwork_sent_since_june_8_location_area.head_count_full?).to eq(false)
    #   paperwork_sent_since_june_8_job_offer_detail
    #   expect(paperwork_sent_since_june_8_location_area.head_count_full?).to eq(false)
    #   paperwork_sent_since_june_8_location_area.update target_head_count: 0
    #   paperwork_sent_since_june_8_location_area.reload
    #   expect(paperwork_sent_since_june_8_location_area.head_count_full?).to eq(true)
    # end

    # it 'is never recruitable when not priority 1' do
    #   low_priority_location_area = create :location_area, priority: 2
    #   expect(low_priority_location_area.head_count_full?).to eq(true)
    # end

    # it 'does not count inactive candidates' do
    #   expect(inactive_candidate_location_area.head_count_full?).to eq(false)
    #   inactive_candidate_shift.update location: inactive_candidate_location
    #   expect(inactive_candidate_location_area.head_count_full?).to eq(false)
    # end
    #
    # it 'returns true if a location areas open head count is 0 or lower' do
    #   expect(recent_trainings_location_area.head_count_full?).to eq(false)
    #   recent_trainings_location_area.update target_head_count: 0
    #   expect(recent_trainings_location_area.head_count_full?).to eq(true)
    # end
  end
end
