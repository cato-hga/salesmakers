require 'rails_helper'

RSpec.describe Location, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :channel }
  it { is_expected.to belong_to :sprint_radio_shack_training_location }
  
  it { is_expected.to have_many :versions }
  it { is_expected.to have_many :location_areas }
  it { is_expected.to have_many :location_client_areas }
  it { is_expected.to have_many :comcast_customers }
  it { is_expected.to have_many :comcast_eods }
  it { is_expected.to have_many :roster_verifications }
  it { is_expected.to have_many :log_entries }

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :display_name }
  it { is_expected.to have_db_column :store_number }
  it { is_expected.to have_db_column :street_1 }
  it { is_expected.to have_db_column :street_2 }
  it { is_expected.to have_db_column :city }
  it { is_expected.to have_db_column :state }
  it { is_expected.to have_db_column :zip }
  it { is_expected.to have_db_column :channel_id }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :latitude }
  it { is_expected.to have_db_column :longitude }
  it { is_expected.to have_db_column :sprint_radio_shack_training_location_id }
  it { is_expected.to have_db_column :cost_center }
  it { is_expected.to have_db_column :mail_stop }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["channel_id"] }
  it { is_expected.to have_db_index ["sprint_radio_shack_training_location_id"] }

  # === Validations (Length) ===
  it { is_expected.to allow_value(Faker::Lorem.characters(2)).for :city }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(1)).for :city }

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :store_number }
  it { is_expected.to validate_presence_of :channel }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end