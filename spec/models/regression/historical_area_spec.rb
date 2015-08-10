require 'rails_helper'

RSpec.describe HistoricalArea, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :area_type }
  it { is_expected.to belong_to :project }
  it { is_expected.to belong_to :area_candidate_sourcing_group }
  
  it { is_expected.to have_many :historical_person_areas }
  it { is_expected.to have_many :historical_people }
  it { is_expected.to have_many :historical_location_areas }
  it { is_expected.to have_many :managers }
  it { is_expected.to have_many :non_managers }
  it { is_expected.to have_many :historical_locations }

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :name }
  it { is_expected.to have_db_column :area_type_id }
  it { is_expected.to have_db_column :ancestry }
  it { is_expected.to have_db_column :project_id }
  it { is_expected.to have_db_column :connect_salesregion_id }
  it { is_expected.to have_db_column :personality_assessment_url }
  it { is_expected.to have_db_column :area_candidate_sourcing_group_id }
  it { is_expected.to have_db_column :email }
  it { is_expected.to have_db_column :active }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :date }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["date"] }

  # === Validations (Length) ===
  it { is_expected.to allow_value(Faker::Lorem.characters(3)).for :name }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(2)).for :name }

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :date }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :area_type }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end