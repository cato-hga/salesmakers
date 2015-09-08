# require 'rails_helper'
#
# RSpec.describe SMSDailyCheck, regressor: true do
#
#   # === Relations ===
#   it { is_expected.to belong_to :person }
#   it { is_expected.to belong_to :sms }
#
#
#
#   # === Nested Attributes ===
#
#
#   # === Database (Columns) ===
#   it { is_expected.to have_db_column :id }
#   it { is_expected.to have_db_column :date }
#   it { is_expected.to have_db_column :person_id }
#   it { is_expected.to have_db_column :sms_id }
#   it { is_expected.to have_db_column :check_in_uniform }
#   it { is_expected.to have_db_column :check_in_on_time }
#   it { is_expected.to have_db_column :check_in_inside_store }
#   it { is_expected.to have_db_column :check_out_on_time }
#   it { is_expected.to have_db_column :check_out_inside_store }
#   it { is_expected.to have_db_column :off_day }
#   it { is_expected.to have_db_column :created_at }
#   it { is_expected.to have_db_column :updated_at }
#   it { is_expected.to have_db_column :out_time }
#   it { is_expected.to have_db_column :in_time }
#   it { is_expected.to have_db_column :roll_call }
#   it { is_expected.to have_db_column :blueforce_geotag }
#   it { is_expected.to have_db_column :accountability_checkin_1 }
#   it { is_expected.to have_db_column :accountability_checkin_2 }
#   it { is_expected.to have_db_column :accountability_checkin_3 }
#   it { is_expected.to have_db_column :sales }
#   it { is_expected.to have_db_column :notes }
#
#   # === Database (Indexes) ===
#
#
#   # === Validations (Length) ===
#
#
#   # === Validations (Presence) ===
#   it { is_expected.to validate_presence_of :person_id }
#   it { is_expected.to validate_presence_of :sms_id }
#   it { is_expected.to validate_presence_of :date }
#
#   # === Validations (Numericality) ===
#
#
#
#   # === Enums ===
#
#
# end