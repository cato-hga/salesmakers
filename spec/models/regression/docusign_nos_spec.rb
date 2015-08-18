require 'rails_helper'

RSpec.describe DocusignNos, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :person }
  it { is_expected.to belong_to :employment_end_reason }
  it { is_expected.to belong_to :manager }
  
  it { is_expected.to have_many :log_entries }

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :person_id }
  it { is_expected.to have_db_column :eligible_to_rehire }
  it { is_expected.to have_db_column :termination_date }
  it { is_expected.to have_db_column :last_day_worked }
  it { is_expected.to have_db_column :employment_end_reason_id }
  it { is_expected.to have_db_column :remarks }
  it { is_expected.to have_db_column :envelope_guid }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :third_party }
  it { is_expected.to have_db_column :manager_id }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["employment_end_reason_id"] }
  it { is_expected.to have_db_index ["person_id"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  context "with conditions" do
    before do
      allow(subject).to receive(:third_party).and_return(false)
    end

    it { is_expected.to validate_presence_of :employment_end_reason_id }
  end

  context "with conditions" do
    before do
      allow(subject).to receive(:third_party).and_return(false)
    end

    it { is_expected.to validate_presence_of :envelope_guid }
  end

  context "with conditions" do
    before do
      allow(subject).to receive(:third_party).and_return(false)
    end

    it { is_expected.to validate_presence_of :last_day_worked }
  end

  it { is_expected.to validate_presence_of :person_id }
  context "with conditions" do
    before do
      allow(subject).to receive(:third_party).and_return(false)
    end

    it { is_expected.to validate_presence_of :termination_date }
  end

  context "with conditions" do
    before do
      allow(subject).to receive(:third_party?).and_return(true)
    end

    it { is_expected.to validate_presence_of :manager_id }
  end


  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end