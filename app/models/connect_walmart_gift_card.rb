# == Schema Information
#
# Table name: rvon_walmart_gift_card
#
#  rvon_walmart_gift_card_id :string(32)       not null, primary key
#  ad_client_id              :string(32)       not null
#  ad_org_id                 :string(32)       not null
#  isactive                  :string(1)        default("Y"), not null
#  created                   :datetime         not null
#  createdby                 :string(32)       not null
#  updated                   :datetime         not null
#  updatedby                 :string(32)       not null
#  link                      :string(255)      not null
#  challenge_code            :string(255)      not null
#  card_number               :string(255)      not null
#  pin                       :string(255)      not null
#  balance                   :decimal(, )      not null
#  purchase_date             :datetime
#  store_number              :string(255)
#  purchase_amount           :decimal(, )
#  m_product_id              :string(32)
#  ad_user_id                :string(32)
#

class ConnectWalmartGiftCard < RealConnectModel
  # Openbravo table name
  self.table_name = 'rvon_walmart_gift_card'
  # Openbravo table primary key column
  self.primary_key = 'rvon_walmart_gift_card_id'
end
