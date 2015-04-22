class SprintSale < ActiveRecord::Base
  validates :sale_date, presence: true
  validates :person, presence: true
  validates :location, presence: true
  validates :meid, length: { is: 18 }
  validates :carrier_name, length: { minimum: 1 }
  validates :handset_model_name, length: { minimum: 1 }
  validates :rate_plan_name, length: { minimum: 1 }
  validates :upgrade, inclusion: { in: [true, false ] }
  validates :top_up_card_purchased, inclusion: { in: [true, false ] }
  validates :phone_activated_in_store, inclusion: { in: [true, false ] }

  belongs_to :person
  belongs_to :location
  belongs_to :connect_sprint_sale,
             primary_key: 'rsprint_sale_id'
end
