# == Schema Information
#
# Table name: permission_groups
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime
#  updated_at :datetime
#

class PermissionGroup < ActiveRecord::Base
  validates :name, length: { minimum: 3 }

  has_many :permissions

  default_scope { order :name }
end
