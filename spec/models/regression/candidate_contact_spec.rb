require 'rails_helper'

RSpec.describe CandidateContact, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :candidate }
  it { is_expected.to belong_to :person }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :contact_method }
  it { is_expected.to have_db_column :inbound }
  it { is_expected.to have_db_column :person_id }
  it { is_expected.to have_db_column :candidate_id }
  it { is_expected.to have_db_column :notes }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :call_results }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["candidate_id"] }
  it { is_expected.to have_db_index ["person_id"] }

  # === Validations (Length) ===
  it { is_expected.to allow_value(Faker::Lorem.characters(10)).for :notes }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(9)).for :notes }

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :contact_method }
  it { is_expected.to validate_presence_of :person }
  it { is_expected.to validate_presence_of :candidate }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  it { is_expected.to define_enum_for(:contact_method).with(["sms", "phone", "email", "video", "google_chat", "group_me", "snail_mail"]) }
  
end