require 'rails_helper'

RSpec.describe Visit, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :person }
  
  it { is_expected.to have_many :ahoy_events }

  # === Nested Attributes ===

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :visitor_id }
  it { is_expected.to have_db_column :ip }
  it { is_expected.to have_db_column :user_agent }
  it { is_expected.to have_db_column :referrer }
  it { is_expected.to have_db_column :landing_page }
  it { is_expected.to have_db_column :person_id }
  it { is_expected.to have_db_column :referring_domain }
  it { is_expected.to have_db_column :search_keyword }
  it { is_expected.to have_db_column :browser }
  it { is_expected.to have_db_column :os }
  it { is_expected.to have_db_column :device_type }
  it { is_expected.to have_db_column :screen_height }
  it { is_expected.to have_db_column :screen_width }
  it { is_expected.to have_db_column :country }
  it { is_expected.to have_db_column :region }
  it { is_expected.to have_db_column :city }
  it { is_expected.to have_db_column :postal_code }
  it { is_expected.to have_db_column :latitude }
  it { is_expected.to have_db_column :longitude }
  it { is_expected.to have_db_column :utm_source }
  it { is_expected.to have_db_column :utm_medium }
  it { is_expected.to have_db_column :utm_term }
  it { is_expected.to have_db_column :utm_content }
  it { is_expected.to have_db_column :utm_campaign }
  it { is_expected.to have_db_column :started_at }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["person_id"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end