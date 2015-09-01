# == Schema Information
#
# Table name: rvon_override_card
#
#  rvon_override_card_id :string(32)       not null, primary key
#  ad_client_id          :string(32)       not null
#  ad_org_id             :string(32)       not null
#  isactive              :string(1)        default("Y"), not null
#  created               :datetime         not null
#  createdby             :string(32)       not null
#  updated               :datetime         not null
#  updatedby             :string(32)       not null
#  card_number           :string(255)      not null
#  original_card_number  :string(255)
#

class ConnectOverrideGiftCard < RealConnectModel
  # Openbravo table name
  self.table_name = 'rvon_override_card'
  # Openbravo table primary key column
  self.primary_key = 'rvon_override_card_id'
end
