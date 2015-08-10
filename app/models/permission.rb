# == Schema Information
#
# Table name: permissions
#
#  id                  :integer          not null, primary key
#  key                 :string           not null
#  description         :string           not null
#  permission_group_id :integer          not null
#  created_at          :datetime
#  updated_at          :datetime
#

class Permission < ActiveRecord::Base
  validates :key, length: { minimum: 5 }
  validates :description, length: { minimum: 10 }
  validates :permission_group, presence: true

  belongs_to :permission_group
  has_and_belongs_to_many :client_representatives
  has_and_belongs_to_many :positions

  default_scope { order :permission_group_id, :description }
end
