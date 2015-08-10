# == Schema Information
#
# Table name: directv_former_providers
#
#  id              :integer          not null, primary key
#  directv_sale_id :integer
#  name            :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class DirecTVFormerProvider < ActiveRecord::Base
  belongs_to :directv_sale

  validates :name, presence: true

  default_scope { order :name }
end
