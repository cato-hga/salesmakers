class Permission < ActiveRecord::Base

  validates :key, length: { minimum: 5 }
  validates :description, length: { minimum: 10 }
  validates :permission_group, presence: true

  belongs_to :permission_group

end
