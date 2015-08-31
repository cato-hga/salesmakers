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
#  project_id                    :integer
#  number_of_accessories         :integer
#

class SprintSale < ActiveRecord::Base
  include SaleAreaAndLocationAreaExtension
  before_validation :strip_mobile_phone

  validates :sale_date, presence: true
  validates :person, presence: true
  validates :location, presence: true
  validates :meid, confirmation: true
  validates :mobile_phone, presence: true
  validates :carrier_name, presence: true
  validates :handset_model_name, presence: true
  validates :rate_plan_name, presence: true
  validates :upgrade, inclusion: { in: [true, false], message: "can't be blank" }
  validates :top_up_card_purchased, inclusion: { in: [true, false], message: "can't be blank" }
  validates :top_up_card_amount, presence: true, if: :card_purchased
  validates :phone_activated_in_store, inclusion: { in: [true, false], message: "can't be blank" }
  validates :reason_not_activated_in_store, presence: true, if: :not_activated
  validates :number_of_accessories, presence: true
  validates :picture_with_customer, presence: true
  validate  :meid_length

  belongs_to :person
  belongs_to :location
  belongs_to :connect_sprint_sale,
             primary_key: 'rsprint_sale_id'

  strip_attributes

  def location_area
    self.location_area_for_sale 'Sprint'
  end

  private

  def meid_length
    if not self.meid or (self.meid.length != 4 and self.meid.length != 18)
      errors.add :meid, 'must be 18 characters in length'
    end
  end

  def strip_mobile_phone
    self.mobile_phone.gsub!(/[^0-9]/, '') if self.mobile_phone
  end

  def card_purchased
    self.top_up_card_purchased && self.top_up_card_purchased == true
  end

  def not_activated
    self.phone_activated_in_store == false
  end
end
