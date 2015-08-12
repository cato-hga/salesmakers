require 'rails_helper'

RSpec.describe SprintSale, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :person }
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
  it { is_expected.to have_db_column :carrier_name }
  it { is_expected.to have_db_column :handset_model_name }
  it { is_expected.to have_db_column :upgrade }
  it { is_expected.to have_db_column :rate_plan_name }
  it { is_expected.to have_db_column :top_up_card_purchased }
  it { is_expected.to have_db_column :top_up_card_amount }
  it { is_expected.to have_db_column :phone_activated_in_store }
  it { is_expected.to have_db_column :reason_not_activated_in_store }
  it { is_expected.to have_db_column :picture_with_customer }
  it { is_expected.to have_db_column :comments }
  it { is_expected.to have_db_column :connect_sprint_sale_id }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["connect_sprint_sale_id"] }
  it { is_expected.to have_db_index ["location_id"] }
  it { is_expected.to have_db_index ["person_id"] }

  # === Validations (Length) ===
  it { is_expected.to allow_value(Faker::Lorem.characters(1)).for :carrier_name }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(0)).for :carrier_name }
  it { is_expected.to allow_value(Faker::Lorem.characters(1)).for :handset_model_name }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(0)).for :handset_model_name }
  it { is_expected.to allow_value(Faker::Lorem.characters(1)).for :rate_plan_name }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(0)).for :rate_plan_name }

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :sale_date }
  it { is_expected.to validate_presence_of :person }
  it { is_expected.to validate_presence_of :location }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end