# == Schema Information
#
# Table name: sprint_sales
#
#  id                                   :integer          not null, primary key
#  sale_date                            :date             not null
#  person_id                            :integer          not null
#  location_id                          :integer          not null
#  meid                                 :string
#  mobile_phone                         :string
#  upgrade                              :boolean          default(FALSE), not null
#  top_up_card_purchased                :boolean          default(FALSE)
#  top_up_card_amount                   :float
#  phone_activated_in_store             :boolean          default(FALSE)
#  reason_not_activated_in_store        :string
#  picture_with_customer                :string
#  comments                             :text
#  connect_sprint_sale_id               :string
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#  project_id                           :integer
#  number_of_accessories                :integer
#  sprint_carrier_id                    :integer
#  sprint_handset_id                    :integer
#  sprint_rate_plan_id                  :integer
#  five_intl_connect                    :boolean
#  ten_intl_connect                     :boolean
#  insurance                            :boolean
#  virgin_data_share_add_on_amount      :float
#  virgin_data_share_add_on_description :text
#

class SprintSale < ActiveRecord::Base
  include SaleAreaAndLocationAreaExtension
  before_validation :strip_mobile_phone

  attr_writer :import

  validates :person, presence: true
  validates :sale_date, presence: true
  validates :location, presence: true
  validates :meid, format: { with: /\A[0-9]{18}\z/i, message: 'must be 18 numbers in length' },
            confirmation: true, if: :meid_not_blank
  validate  :meid_cannot_be_blank, if: :prepaid_project
  validates :mobile_phone, presence: true, if: :prepaid_project
  validates :upgrade, inclusion: { in: [true, false], message: "or New Activation must be chosen" }
  validates :sprint_carrier_id, presence: true, if: :prepaid_project
  validates :sprint_handset_id, presence: true
  validates :sprint_rate_plan_id, presence: true
  validates :top_up_card_purchased, inclusion: { in: [true, false], message: "can't be blank" }
  validates :top_up_card_amount, presence: true, if: :card_purchased
  validates :phone_activated_in_store, inclusion: { in: [true, false], message: "can't be blank" }
  validates :reason_not_activated_in_store, presence: true, if: :not_activated
  validates :number_of_accessories, presence: true, if: :postpaid_project
  validates :picture_with_customer, presence: true
  validate  :sale_date_cannot_be_more_than_1_month_in_the_past, unless: :import?

  belongs_to :person
  belongs_to :project
  belongs_to :location
  belongs_to :connect_sprint_sale,
             primary_key: 'rsprint_sale_id'

  belongs_to :sprint_carrier
  belongs_to :sprint_handset
  belongs_to :sprint_rate_plan

  strip_attributes

  scope :for_date_range, ->(start_date, end_date) {
    where "sale_date >= ? AND sale_date <= ?", start_date, end_date
  }

  def location_area
    self.location_area_for_sale 'Sprint'
  end

  def prepaid_project
    prepaid = Project.find_by(name: 'Sprint Retail')
    self.project_id == prepaid.id if prepaid
  end

  def postpaid_project
    postpaid = Project.find_by(name: 'Sprint Postpaid')
    self.project_id == postpaid.id if postpaid
  end

  def import?
    return false unless @import
    @import
  end

  private

  def meid_not_blank
    !self.meid.blank?
  end

  def meid_cannot_be_blank
    errors.add(:meid, "can't be blank") if self.meid.blank?
  end

  def strip_mobile_phone
    self.mobile_phone.gsub!(/[^0-9]/, '') if self.mobile_phone
  end

  def card_purchased
    if self.prepaid_project
      self.top_up_card_purchased && self.top_up_card_purchased == true
    end
  end

  def project_cannot_be_blank
    if self.prepaid_project
      errors.add("New Service can't be blank") if self.upgrade.blank?
    end
  end

  def sale_date_cannot_be_more_than_1_month_in_the_past
    errors.add(:sale_date, "cannot be dated for more than 1 month in the past") if self.sale_date and self.sale_date <= 1.month.ago
  end

  def not_activated
    if self.prepaid_project
      self.phone_activated_in_store == false
    end
  end
end
