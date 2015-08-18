require 'rails_helper'

RSpec.describe Area, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :area_type }
  it { is_expected.to belong_to :project }
  it { is_expected.to belong_to :area_candidate_sourcing_group }
  
  it { is_expected.to have_many :log_entries }
  it { is_expected.to have_many :versions }
  it { is_expected.to have_many :person_areas }
  it { is_expected.to have_many :people }
  it { is_expected.to have_many :day_sales_counts }
  it { is_expected.to have_many :sales_performance_ranks }
  it { is_expected.to have_many :location_areas }
  it { is_expected.to have_many :group_me_groups }
  it { is_expected.to have_many :vonage_rep_sale_payout_brackets }
  it { is_expected.to have_many :managers }
  it { is_expected.to have_many :non_managers }
  it { is_expected.to have_many :locations }

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :name }
  it { is_expected.to have_db_column :area_type_id }
  it { is_expected.to have_db_column :ancestry }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :project_id }
  it { is_expected.to have_db_column :connect_salesregion_id }
  it { is_expected.to have_db_column :personality_assessment_url }
  it { is_expected.to have_db_column :area_candidate_sourcing_group_id }
  it { is_expected.to have_db_column :email }
  it { is_expected.to have_db_column :active }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["ancestry"] }
  it { is_expected.to have_db_index ["area_candidate_sourcing_group_id"] }
  it { is_expected.to have_db_index ["area_type_id"] }
  it { is_expected.to have_db_index ["project_id"] }

  # === Validations (Length) ===
  it { is_expected.to allow_value(Faker::Lorem.characters(3)).for :name }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(2)).for :name }

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :area_type }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end