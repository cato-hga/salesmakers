# == Schema Information
#
# Table name: rsprint_sales
#
#  rsprint_sales_id       :string(32)       not null, primary key
#  ad_client_id           :string(32)       not null
#  ad_org_id              :string(32)       not null
#  isactive               :string(1)        default("Y"), not null
#  created                :datetime         not null
#  createdby              :string(32)       not null
#  updated                :datetime         not null
#  updatedby              :string(32)       not null
#  ad_user_id             :string(32)       not null
#  c_bpartner_location_id :string(32)       not null
#  date_sold              :datetime         not null
#  upgrade                :string(1)        default("N"), not null
#  carrier                :string(255)      not null
#  model                  :string(255)      not null
#  rate_plan              :string(255)      not null
#  comments               :string(2000)
#  meid                   :string(255)
#  activation_assistance  :string(1)
#  picture                :string(255)
#  intl_connect_five      :string(1)        default("N")
#  intl_connect_ten       :string(1)        default("N")
#  insurance              :string(1)        default("N")
#  top_up_card_purchased  :string(255)
#  top_up_card_amount     :decimal(, )
#  activated_in_store     :string(255)
#  activation_type        :string(255)
#  reason_not_activated   :string(255)
#  addon_amount           :decimal(, )
#  addon_description      :string(2000)
#  mobile_phone           :string(255)
#

# Openbravo orders
class ConnectSprintSale < RealConnectModel
  # Openbravo table name
  self.table_name = 'rsprint_sales'
  # Openbravo table primary key column
  self.primary_key = 'rsprint_sales_id'

  # Relationship for the Openbravo asset records
  belongs_to :connect_user,
           primary_key: 'ad_user_id',
           foreign_key: 'ad_user_id'
  belongs_to :connect_business_partner_location,
             foreign_key: 'c_bpartner_location_id',
             primary_key: 'c_bpartner_location_id'

  scope :today, -> {
    where('date_sold = ?', Date.today)
  }

  scope :sold_between_dates, ->(start_date, end_date) {
    return none unless start_date and end_date
    where('date_sold >= ? AND date_sold <= ?', start_date, end_date)
  }

  def date_sold
    self[:date_sold].remove_eastern_offset
  end

  def location
    if self.connect_business_partner_location
      self.connect_business_partner_location
    else
      nil
    end
  end

  def connect_region
    if self.connect_business_partner_location
      self.connect_business_partner_location.connect_region
    else
      nil
    end
  end

  def area
    connect_salesregion = self.connect_region
    return nil unless connect_salesregion
    Area.find_by connect_salesregion_id: connect_salesregion.c_salesregion_id
  end

  def person
    return nil unless self.connect_user
    Person.find_by connect_user_id: self.connect_user.ad_user_id
  end

end
