# == Schema Information
#
# Table name: workmarket_locations
#
#  id                      :integer          not null, primary key
#  workmarket_location_num :string           not null
#  name                    :string           not null
#  location_number         :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class WorkmarketLocation < ActiveRecord::Base
  validates :workmarket_location_num, presence: true
  validates :name, length: { minimum: 1 }

  has_many :workmarket_assignments,
           foreign_key: :workmarket_location_num,
           primary_key: :workmarket_location_num
end
