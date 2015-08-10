require 'rails_helper'

RSpec.describe ChangelogEntry, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :project }
  it { is_expected.to belong_to :department }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :department_id }
  it { is_expected.to have_db_column :project_id }
  it { is_expected.to have_db_column :all_hq }
  it { is_expected.to have_db_column :all_field }
  it { is_expected.to have_db_column :heading }
  it { is_expected.to have_db_column :description }
  it { is_expected.to have_db_column :released }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["department_id"] }
  it { is_expected.to have_db_index ["project_id"] }

  # === Validations (Length) ===
  it { is_expected.to allow_value(Faker::Lorem.characters(5)).for :heading }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(4)).for :heading }
  it { is_expected.to allow_value(Faker::Lorem.characters(20)).for :description }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(19)).for :description }

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :released }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end