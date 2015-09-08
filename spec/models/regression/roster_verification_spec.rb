require 'rails_helper'

RSpec.describe RosterVerification, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :roster_verification_session }
  it { is_expected.to belong_to :creator }
  it { is_expected.to belong_to :person }
  it { is_expected.to belong_to :location }
  
  it { is_expected.to have_many :log_entries }

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :creator_id }
  it { is_expected.to have_db_column :person_id }
  it { is_expected.to have_db_column :status }
  it { is_expected.to have_db_column :last_shift_date }
  it { is_expected.to have_db_column :location_id }
  it { is_expected.to have_db_column :envelope_guid }
  it { is_expected.to have_db_column :roster_verification_session_id }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :issue }

  # === Database (Indexes) ===
  

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :creator }
  it { is_expected.to validate_presence_of :person }
  it { is_expected.to validate_presence_of :status }
  it { is_expected.to validate_presence_of :roster_verification_session }
  context "with conditions" do
    before do
      allow(subject).to receive(:issue?).and_return(true)
    end

    it { is_expected.to validate_presence_of :issue }
  end


  # === Validations (Numericality) ===
  

  
  # === Enums ===
  it { is_expected.to define_enum_for(:status).with(["active", "terminate", "issue"]) }
  
end