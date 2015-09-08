require 'rails_helper'

RSpec.describe GiftCardOverride, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :creator }
  it { is_expected.to belong_to :person }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :creator_id }
  it { is_expected.to have_db_column :person_id }
  it { is_expected.to have_db_column :original_card_number }
  it { is_expected.to have_db_column :ticket_number }
  it { is_expected.to have_db_column :override_card_number }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  

  # === Validations (Length) ===
  context "with conditions" do
    before do
      allow(subject).to receive(:ticket_number).and_return(false)
    end


  end

  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :creator }
  context "with conditions" do
    before do
      allow(subject).to receive(:import?).and_return(false)
    end

    it { is_expected.to validate_presence_of :person }
  end

  context "with conditions" do
    before do
      allow(subject).to receive(:original_card_number).and_return(false)
    end

    it { is_expected.to validate_presence_of :ticket_number }
  end


  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end