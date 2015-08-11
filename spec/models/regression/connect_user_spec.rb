require 'rails_helper'

RSpec.describe ConnectUser, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :supervisor }
  it { is_expected.to belong_to :creator }
  it { is_expected.to belong_to :updater }
  it { is_expected.to have_one :person }
  it { is_expected.to have_one :connect_business_partner }
  it { is_expected.to have_many :connect_regions }
  it { is_expected.to have_many :employees }
  it { is_expected.to have_many :connect_terminations }
  it { is_expected.to have_many :connect_user_mappings }

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :ad_user_id }
  it { is_expected.to have_db_column :ad_client_id }
  it { is_expected.to have_db_column :ad_org_id }
  it { is_expected.to have_db_column :isactive }
  it { is_expected.to have_db_column :created }
  it { is_expected.to have_db_column :createdby }
  it { is_expected.to have_db_column :updated }
  it { is_expected.to have_db_column :updatedby }
  it { is_expected.to have_db_column :name }
  it { is_expected.to have_db_column :description }
  it { is_expected.to have_db_column :password }
  it { is_expected.to have_db_column :email }
  it { is_expected.to have_db_column :supervisor_id }
  it { is_expected.to have_db_column :c_bpartner_id }
  it { is_expected.to have_db_column :processing }
  it { is_expected.to have_db_column :emailuser }
  it { is_expected.to have_db_column :emailuserpw }
  it { is_expected.to have_db_column :c_bpartner_location_id }
  it { is_expected.to have_db_column :c_greeting_id }
  it { is_expected.to have_db_column :title }
  it { is_expected.to have_db_column :comments }
  it { is_expected.to have_db_column :phone }
  it { is_expected.to have_db_column :phone2 }
  it { is_expected.to have_db_column :fax }
  it { is_expected.to have_db_column :lastcontact }
  it { is_expected.to have_db_column :lastresult }
  it { is_expected.to have_db_column :birthday }
  it { is_expected.to have_db_column :ad_orgtrx_id }
  it { is_expected.to have_db_column :firstname }
  it { is_expected.to have_db_column :lastname }
  it { is_expected.to have_db_column :username }
  it { is_expected.to have_db_column :default_ad_client_id }
  it { is_expected.to have_db_column :default_ad_language }
  it { is_expected.to have_db_column :default_ad_org_id }
  it { is_expected.to have_db_column :default_ad_role_id }
  it { is_expected.to have_db_column :default_m_warehouse_id }
  it { is_expected.to have_db_column :islocked }

  # === Database (Indexes) ===
  

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end