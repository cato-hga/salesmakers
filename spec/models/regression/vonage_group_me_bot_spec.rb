require 'rails_helper'

RSpec.describe VonageGroupMeBot, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :area }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :group_num }
  it { is_expected.to have_db_column :bot_num }
  it { is_expected.to have_db_column :area_id }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :group_num }
  it { is_expected.to validate_presence_of :bot_num }
  it { is_expected.to validate_presence_of :area_id }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end