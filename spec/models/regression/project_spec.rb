require 'rails_helper'

RSpec.describe Project, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :client }
  
  it { is_expected.to have_many :area_types }
  it { is_expected.to have_many :areas }
  it { is_expected.to have_many :client_area_types }
  it { is_expected.to have_many :client_areas }
  it { is_expected.to have_many :day_sales_counts }
  it { is_expected.to have_many :shifts }

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :name }
  it { is_expected.to have_db_column :client_id }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :workmarket_project_num }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["client_id"] }

  # === Validations (Length) ===
  it { is_expected.to allow_value(Faker::Lorem.characters(4)).for :name }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(3)).for :name }

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :client }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end