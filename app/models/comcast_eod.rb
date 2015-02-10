class ComcastEod < ActiveRecord::Base

  validates :location_id, presence: true
  validates :sales_pro_visit, inclusion: {in: [true, false]}
  validates :comcast_visit, inclusion: {in: [true, false]}
  validates :cloud_training, inclusion: {in: [true, false]}

  belongs_to :location

end
