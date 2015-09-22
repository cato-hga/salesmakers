require 'rails_helper'

RSpec.describe Attachment, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :attachable }
  it { is_expected.to belong_to :person }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :name }
  it { is_expected.to have_db_column :attachable_id }
  it { is_expected.to have_db_column :attachable_type }
  it { is_expected.to have_db_column :attachment_uid }
  it { is_expected.to have_db_column :attachment_name }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :person_id }

  # === Database (Indexes) ===
  

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :attachable }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :person }
  it { is_expected.to validate_presence_of :attachment }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end