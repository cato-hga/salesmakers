class DirecTVFormerProvider < ActiveRecord::Base
  belongs_to :directv_sale

  validates :name, presence: true

  default_scope { order :name }
end
