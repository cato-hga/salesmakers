# == Schema Information
#
# Table name: workmarket_fields
#
#  id                       :integer          not null, primary key
#  workmarket_assignment_id :integer          not null
#  name                     :string           not null
#  value                    :string           not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

class WorkmarketField < ActiveRecord::Base
  validates :workmarket_assignment, presence: true
  validates :name, length: { minimum: 1 }
  validates :value, length: { minimum: 1 }

  belongs_to :workmarket_assignment
end
