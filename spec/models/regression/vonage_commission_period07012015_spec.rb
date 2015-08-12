require 'rails_helper'

RSpec.describe VonageCommissionPeriod07012015, regressor: true do

  # === Relations ===
  
  
  it { is_expected.to have_many :vcp07012015_hps_sales }
  it { is_expected.to have_many :vcp07012015_hps_shifts }
  it { is_expected.to have_many :vcp07012015_vested_sales_shifts }
  it { is_expected.to have_many :vcp07012015_vested_sales_sales }

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :name }
  it { is_expected.to have_db_column :hps_start }
  it { is_expected.to have_db_column :hps_end }
  it { is_expected.to have_db_column :vested_sales_start }
  it { is_expected.to have_db_column :vested_sales_end }
  it { is_expected.to have_db_column :cutoff }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  

  # === Validations (Length) ===
  it { is_expected.to allow_value(Faker::Lorem.characters(4)).for :name }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(3)).for :name }

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :cutoff }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end