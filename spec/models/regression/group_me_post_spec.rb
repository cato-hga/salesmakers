require 'rails_helper'

RSpec.describe GroupMePost, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :group_me_user }
  it { is_expected.to belong_to :group_me_group }
  it { is_expected.to belong_to :person }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :group_me_group_id }
  it { is_expected.to have_db_column :posted_at }
  it { is_expected.to have_db_column :json }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :group_me_user_id }
  it { is_expected.to have_db_column :message_num }
  it { is_expected.to have_db_column :like_count }
  it { is_expected.to have_db_column :person_id }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["group_me_group_id"] }
  it { is_expected.to have_db_index ["group_me_user_id"] }
  it { is_expected.to have_db_index ["person_id"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end