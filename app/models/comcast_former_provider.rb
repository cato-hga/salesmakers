class ComcastFormerProvider < ActiveRecord::Base
  belongs_to :comcast_sale

  validates :name, presence: true
end
