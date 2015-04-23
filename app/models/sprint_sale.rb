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
