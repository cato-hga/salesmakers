# == Schema Information
#
# Table name: comcast_former_providers
#
#  id              :integer          not null, primary key
#  name            :string           not null
#  comcast_sale_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class ComcastFormerProvider < ActiveRecord::Base
  belongs_to :comcast_sale

  validates :name, presence: true

  default_scope { order :name }
end
