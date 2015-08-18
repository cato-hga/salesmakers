require 'rails_helper'

RSpec.describe Candidate, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :location_area }
  it { is_expected.to belong_to :person }
  it { is_expected.to belong_to :candidate_source }
  it { is_expected.to belong_to :candidate_denial_reason }
  it { is_expected.to belong_to :created_by }
  it { is_expected.to belong_to :sprint_radio_shack_training_session }
  it { is_expected.to belong_to :potential_area }
  it { is_expected.to have_one :candidate_availability }
  it { is_expected.to have_one :training_availability }
  it { is_expected.to have_one :sprint_pre_training_welcome_call }
  it { is_expected.to have_one :candidate_drug_test }
  it { is_expected.to have_many :log_entries }
  it { is_expected.to have_many :versions }
  it { is_expected.to have_many :taggings }
  it { is_expected.to have_many :base_tags }
  it { is_expected.to have_many :tag_taggings }
  it { is_expected.to have_many :tags }
  it { is_expected.to have_many :prescreen_answers }
  it { is_expected.to have_many :interview_schedules }
  it { is_expected.to have_many :interview_answers }
  it { is_expected.to have_many :job_offer_details }
  it { is_expected.to have_many :candidate_contacts }
  it { is_expected.to have_many :candidate_reconciliations }
  it { is_expected.to have_many :candidate_notes }
  it { is_expected.to have_many :candidate_sprint_radio_shack_training_sessions }
  it { is_expected.to have_many :communication_log_entries }

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :first_name }
  it { is_expected.to have_db_column :last_name }
  it { is_expected.to have_db_column :suffix }
  it { is_expected.to have_db_column :mobile_phone }
  it { is_expected.to have_db_column :email }
  it { is_expected.to have_db_column :zip }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :person_id }
  it { is_expected.to have_db_column :location_area_id }
  it { is_expected.to have_db_column :latitude }
  it { is_expected.to have_db_column :longitude }
  it { is_expected.to have_db_column :active }
  it { is_expected.to have_db_column :status }
  it { is_expected.to have_db_column :state }
  it { is_expected.to have_db_column :candidate_source_id }
  it { is_expected.to have_db_column :created_by }
  it { is_expected.to have_db_column :candidate_denial_reason_id }
  it { is_expected.to have_db_column :personality_assessment_completed }
  it { is_expected.to have_db_column :shirt_gender }
  it { is_expected.to have_db_column :shirt_size }
  it { is_expected.to have_db_column :personality_assessment_status }
  it { is_expected.to have_db_column :personality_assessment_score }
  it { is_expected.to have_db_column :sprint_radio_shack_training_session_id }
  it { is_expected.to have_db_column :potential_area_id }
  it { is_expected.to have_db_column :training_session_status }
  it { is_expected.to have_db_column :sprint_roster_status }
  it { is_expected.to have_db_column :time_zone }
  it { is_expected.to have_db_column :other_phone }
  it { is_expected.to have_db_column :mobile_phone_valid }
  it { is_expected.to have_db_column :other_phone_valid }
  it { is_expected.to have_db_column :mobile_phone_is_landline }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["candidate_denial_reason_id"] }
  it { is_expected.to have_db_index ["candidate_source_id"] }
  it { is_expected.to have_db_index ["created_by"] }
  it { is_expected.to have_db_index ["location_area_id"] }
  it { is_expected.to have_db_index ["person_id"] }
  it { is_expected.to have_db_index ["potential_area_id"] }
  it { is_expected.to have_db_index ["sprint_radio_shack_training_session_id"] }

  # === Validations (Length) ===
  it { is_expected.to allow_value(Faker::Lorem.characters(2)).for :first_name }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(1)).for :first_name }
  it { is_expected.to allow_value(Faker::Lorem.characters(2)).for :last_name }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(1)).for :last_name }
  
  
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :first_name }
  it { is_expected.to validate_presence_of :last_name }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :candidate_source_id }
  it { is_expected.to validate_presence_of :created_by }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  it { is_expected.to define_enum_for(:status).with(["entered", "prescreened", "location_selected", "interview_scheduled", "interviewed", "rejected", "accepted", "confirmed", "paperwork_sent", "paperwork_completed_by_candidate", "paperwork_completed_by_advocate", "paperwork_completed_by_hr", "onboarded", "partially_screened", "fully_screened"]) }
  it { is_expected.to define_enum_for(:personality_assessment_status).with(["incomplete", "disqualified", "qualified"]) }
  it { is_expected.to define_enum_for(:training_session_status).with(["pending", "candidate_confirmed", "shadow_confirmed", "in_class", "completed", "did_not_graduate", "did_not_attend", "not_interested", "future_training_class", "nos", "nclb", "transfer", "transfer_reject", "moved_to_other_project"]) }
  it { is_expected.to define_enum_for(:sprint_roster_status).with(["roster_status_pending", "sprint_submitted", "sprint_confirmed", "sprint_rejected", "sprint_preconfirmed"]) }
  
end