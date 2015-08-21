require 'rails_helper'

RSpec.describe InterviewAnswer, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :candidate }
  
  it { is_expected.to have_many :log_entries }

  # === Nested Attributes ===
  it { is_expected.to accept_nested_attributes_for :candidate }

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :work_history }
  it { is_expected.to have_db_column :why_in_market }
  it { is_expected.to have_db_column :ideal_position }
  it { is_expected.to have_db_column :what_are_you_good_at }
  it { is_expected.to have_db_column :what_are_you_not_good_at }
  it { is_expected.to have_db_column :compensation_last_job_one }
  it { is_expected.to have_db_column :compensation_last_job_two }
  it { is_expected.to have_db_column :compensation_last_job_three }
  it { is_expected.to have_db_column :compensation_seeking }
  it { is_expected.to have_db_column :hours_looking_to_work }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :candidate_id }
  it { is_expected.to have_db_column :willingness_characteristic }
  it { is_expected.to have_db_column :personality_characteristic }
  it { is_expected.to have_db_column :self_motivated_characteristic }
  it { is_expected.to have_db_column :last_two_positions }
  it { is_expected.to have_db_column :what_interests_you }
  it { is_expected.to have_db_column :first_thing_you_sold }
  it { is_expected.to have_db_column :first_building_of_working_relationship }
  it { is_expected.to have_db_column :first_rely_on_teaching }
  it { is_expected.to have_db_column :availability_confirm }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["candidate_id"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :work_history }
  it { is_expected.to validate_presence_of :what_interests_you }
  it { is_expected.to validate_presence_of :first_thing_you_sold }
  it { is_expected.to validate_presence_of :first_building_of_working_relationship }
  it { is_expected.to validate_presence_of :compensation_seeking }
  it { is_expected.to validate_presence_of :first_rely_on_teaching }
  it { is_expected.to validate_presence_of :personality_characteristic }
  it { is_expected.to validate_presence_of :self_motivated_characteristic }
  it { is_expected.to validate_presence_of :willingness_characteristic }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end