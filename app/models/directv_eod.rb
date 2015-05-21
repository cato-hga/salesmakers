class DirecTVEod < ActiveRecord::Base

  validates :location_id, presence: true
  validates :person_id, presence: true
  validates :sales_pro_visit, inclusion: { in: [true, false] }
  validates :directv_visit, inclusion: { in: [true, false] }
  validates :cloud_training, inclusion: { in: [true, false] }

  belongs_to :location
  belongs_to :person

  def self.policy_class
    DirecTVCustomerPolicy
  end
end
