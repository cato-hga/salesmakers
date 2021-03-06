require 'rails_helper'

RSpec.describe ClientArea, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :client_area_type }
  it { is_expected.to belong_to :project }
  
  it { is_expected.to have_many :versions }
  it { is_expected.to have_many :location_client_areas }

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :name }
  it { is_expected.to have_db_column :client_area_type_id }
  it { is_expected.to have_db_column :ancestry }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :project_id }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["ancestry"] }

  # === Validations (Length) ===
  it { is_expected.to allow_value(Faker::Lorem.characters(3)).for :name }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(2)).for :name }

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :client_area_type }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end