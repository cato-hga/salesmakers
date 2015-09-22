require 'rails_helper'

RSpec.describe SprintSale, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :person }
  it { is_expected.to belong_to :project }
  it { is_expected.to belong_to :location }
  it { is_expected.to belong_to :connect_sprint_sale }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :sale_date }
  it { is_expected.to have_db_column :person_id }
  it { is_expected.to have_db_column :location_id }
  it { is_expected.to have_db_column :meid }
  it { is_expected.to have_db_column :mobile_phone }
  it { is_expected.to have_db_column :upgrade }
  it { is_expected.to have_db_column :top_up_card_purchased }
  it { is_expected.to have_db_column :top_up_card_amount }
  it { is_expected.to have_db_column :phone_activated_in_store }
  it { is_expected.to have_db_column :reason_not_activated_in_store }
  it { is_expected.to have_db_column :picture_with_customer }
  it { is_expected.to have_db_column :comments }
  it { is_expected.to have_db_column :connect_sprint_sale_id }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :project_id }
  it { is_expected.to have_db_column :number_of_accessories }
  it { is_expected.to have_db_column :sprint_carrier_id }
  it { is_expected.to have_db_column :sprint_handset_id }
  it { is_expected.to have_db_column :sprint_rate_plan_id }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["connect_sprint_sale_id"] }
  it { is_expected.to have_db_index ["location_id"] }
  it { is_expected.to have_db_index ["person_id"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :person }
  it { is_expected.to validate_presence_of :sale_date }
  it { is_expected.to validate_presence_of :location }
  context "with conditions" do
    before do
      allow(subject).to receive(:prepaid_project).and_return(true)
    end

    it { is_expected.to validate_presence_of :mobile_phone }
  end

  context "with conditions" do
    before do
      allow(subject).to receive(:prepaid_project).and_return(true)
    end

    it { is_expected.to validate_presence_of :sprint_carrier_id }
  end

  it { is_expected.to validate_presence_of :sprint_handset_id }
  it { is_expected.to validate_presence_of :sprint_rate_plan_id }
  context "with conditions" do
    before do
      allow(subject).to receive(:card_purchased).and_return(true)
    end

    it { is_expected.to validate_presence_of :top_up_card_amount }
  end

  context "with conditions" do
    before do
      allow(subject).to receive(:not_activated).and_return(true)
    end

    it { is_expected.to validate_presence_of :reason_not_activated_in_store }
  end

  context "with conditions" do
    before do
      allow(subject).to receive(:star_project).and_return(true)
    end

    it { is_expected.to validate_presence_of :number_of_accessories }
  end

  it { is_expected.to validate_presence_of :picture_with_customer }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end