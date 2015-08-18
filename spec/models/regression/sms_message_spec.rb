require 'rails_helper'

RSpec.describe SMSMessage, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :to_person }
  it { is_expected.to belong_to :from_person }
  it { is_expected.to belong_to :to_candidate }
  it { is_expected.to belong_to :from_candidate }
  
  it { is_expected.to have_many :log_entries }

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :from_num }
  it { is_expected.to have_db_column :to_num }
  it { is_expected.to have_db_column :from_person_id }
  it { is_expected.to have_db_column :to_person_id }
  it { is_expected.to have_db_column :inbound }
  it { is_expected.to have_db_column :reply_to_sms_message_id }
  it { is_expected.to have_db_column :replied_to }
  it { is_expected.to have_db_column :message }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :sid }
  it { is_expected.to have_db_column :from_candidate_id }
  it { is_expected.to have_db_column :to_candidate_id }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["from_candidate_id"] }
  it { is_expected.to have_db_index ["from_person_id"] }
  it { is_expected.to have_db_index ["to_candidate_id"] }
  it { is_expected.to have_db_index ["to_person_id"] }

  # === Validations (Length) ===
  
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :message }
  it { is_expected.to validate_presence_of :sid }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end