# == Schema Information
#
# Table name: sprint_sales
#
#  id                            :integer          not null, primary key
#  sale_date                     :date             not null
#  person_id                     :integer          not null
#  location_id                   :integer          not null
#  meid                          :string           not null
#  mobile_phone                  :string
#  carrier_name                  :string           not null
#  handset_model_name            :string           not null
#  upgrade                       :boolean          default(FALSE), not null
#  rate_plan_name                :string           not null
#  top_up_card_purchased         :boolean          default(FALSE), not null
#  top_up_card_amount            :float
#  phone_activated_in_store      :boolean          default(FALSE), not null
#  reason_not_activated_in_store :string
#  picture_with_customer         :string
#  comments                      :text
#  connect_sprint_sale_id        :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#

class SprintSale < ActiveRecord::Base
  include SaleAreaAndLocationAreaExtension

  validates :sale_date, presence: true
  validates :person, presence: true
  validates :location, presence: true
  validates :carrier_name, length: { minimum: 1 }
  validates :handset_model_name, length: { minimum: 1 }
  validates :rate_plan_name, length: { minimum: 1 }
  validates :upgrade, inclusion: { in: [true, false ] }
  validates :top_up_card_purchased, inclusion: { in: [true, false ] }
  validates :phone_activated_in_store, inclusion: { in: [true, false ] }
  validate :meid_length

  belongs_to :person
  belongs_to :location
  belongs_to :connect_sprint_sale,
             primary_key: 'rsprint_sale_id'

  def location_area
    self.location_area_for_sale 'Sprint'
  end

  private

  def meid_length
    if not self.meid or (self.meid.length != 4 and self.meid.length != 18)
      errors.add :meid, 'must be 18 characters in length'
    end
  end
end
