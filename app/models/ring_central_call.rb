class RingCentralCall < ActiveRecord::Base
  validates :ring_central_call_num, presence: true
  validates :json, presence: true
end
