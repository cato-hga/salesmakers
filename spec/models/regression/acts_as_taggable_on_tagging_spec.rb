require 'rails_helper'

RSpec.describe ActsAsTaggableOn::Tagging, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :tag }
  it { is_expected.to belong_to :taggable }
  it { is_expected.to belong_to :tagger }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :tag_id }
  it { is_expected.to have_db_column :taggable_id }
  it { is_expected.to have_db_column :taggable_type }
  it { is_expected.to have_db_column :tagger_id }
  it { is_expected.to have_db_column :tagger_type }
  it { is_expected.to have_db_column :context }
  it { is_expected.to have_db_column :created_at }

  # === Database (Indexes) ===
  

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :context }
  it { is_expected.to validate_presence_of :tag_id }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end