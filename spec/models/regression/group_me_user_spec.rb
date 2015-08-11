require 'rails_helper'

RSpec.describe GroupMeUser, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :person }
  
  it { is_expected.to have_many :group_me_posts }

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :group_me_user_num }
  it { is_expected.to have_db_column :person_id }
  it { is_expected.to have_db_column :name }
  it { is_expected.to have_db_column :avatar_url }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["person_id"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end