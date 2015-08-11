require 'rails_helper'

RSpec.describe WorkmarketAssignment, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :project }
  it { is_expected.to belong_to :workmarket_location }
  
  it { is_expected.to have_many :workmarket_attachments }
  it { is_expected.to have_many :workmarket_fields }

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :project_id }
  it { is_expected.to have_db_column :json }
  it { is_expected.to have_db_column :workmarket_assignment_num }
  it { is_expected.to have_db_column :title }
  it { is_expected.to have_db_column :worker_name }
  it { is_expected.to have_db_column :worker_first_name }
  it { is_expected.to have_db_column :worker_last_name }
  it { is_expected.to have_db_column :worker_email }
  it { is_expected.to have_db_column :cost }
  it { is_expected.to have_db_column :started }
  it { is_expected.to have_db_column :ended }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :workmarket_location_num }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["project_id"] }
  it { is_expected.to have_db_index ["workmarket_location_num"] }

  # === Validations (Length) ===
  it { is_expected.to allow_value(Faker::Lorem.characters(2)).for :json }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(1)).for :json }
  it { is_expected.to allow_value(Faker::Lorem.characters(1)).for :title }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(0)).for :title }
  it { is_expected.to allow_value(Faker::Lorem.characters(3)).for :worker_name }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(2)).for :worker_name }
  it { is_expected.to allow_value(Faker::Lorem.characters(1)).for :worker_email }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(0)).for :worker_email }
  it { is_expected.to allow_value(Faker::Lorem.characters(1)).for :workmarket_location_num }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(0)).for :workmarket_location_num }

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :project }
  it { is_expected.to validate_presence_of :workmarket_assignment_num }
  it { is_expected.to validate_presence_of :started }
  it { is_expected.to validate_presence_of :ended }

  # === Validations (Numericality) ===
  it { is_expected.to validate_numericality_of(:cost).is_greater_than_or_equal_to(0) }
  it { is_expected.not_to validate_numericality_of(:cost).is_greater_than_or_equal_to(-1) }

  
  # === Enums ===
  
  
end