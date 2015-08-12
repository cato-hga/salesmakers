require 'rails_helper'

RSpec.describe ActsAsTaggableOn::Tag, regressor: true do

  # === Relations ===
  
  
  it { is_expected.to have_many :taggings }

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :name }

  # === Database (Indexes) ===
  

  # === Validations (Length) ===
  it { is_expected.to allow_value(Faker::Lorem.characters(255)).for :name }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(256)).for :name }

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :name }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end