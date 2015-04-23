class PermissionGroup < ActiveRecord::Base
  validates :name, length: { minimum: 3 }

  has_many :permissions

  default_scope { order :name }
end
