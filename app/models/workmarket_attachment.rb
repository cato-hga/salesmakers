# == Schema Information
#
# Table name: workmarket_attachments
#
#  id                       :integer          not null, primary key
#  workmarket_assignment_id :integer          not null
#  filename                 :string           not null
#  url                      :string           not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  guid                     :string           not null
#

class WorkmarketAttachment < ActiveRecord::Base
  validates :workmarket_assignment, presence: true
  validates :filename, length: { minimum: 1 }
  validates :url, length: { minimum: 14 }
  validates :guid, length: { minimum: 1 }

  belongs_to :workmarket_assignment
end
