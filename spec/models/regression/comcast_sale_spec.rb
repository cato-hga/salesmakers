require 'rails_helper'

RSpec.describe ComcastSale, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :comcast_customer }
  it { is_expected.to belong_to :comcast_lead }
  it { is_expected.to belong_to :person }
  it { is_expected.to have_one :comcast_former_provider }
  it { is_expected.to have_one :comcast_install_appointment }
  

  # === Nested Attributes ===
  it { is_expected.to accept_nested_attributes_for :comcast_install_appointment }

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :order_date }
  it { is_expected.to have_db_column :person_id }
  it { is_expected.to have_db_column :comcast_customer_id }
  it { is_expected.to have_db_column :order_number }
  it { is_expected.to have_db_column :tv }
  it { is_expected.to have_db_column :internet }
  it { is_expected.to have_db_column :phone }
  it { is_expected.to have_db_column :security }
  it { is_expected.to have_db_column :customer_acknowledged }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :comcast_former_provider_id }
  it { is_expected.to have_db_column :comcast_lead_id }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["comcast_customer_id"] }
  it { is_expected.to have_db_index ["person_id"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :order_date }
  it { is_expected.to validate_presence_of :person_id }
  it { is_expected.to validate_presence_of :comcast_customer_id }
  it { is_expected.to validate_presence_of :comcast_install_appointment }

  # === Validations (Numericality) ===
  it { is_expected.to validate_numericality_of(:order_number).only_integer }

  
  # === Enums ===
  
  
end