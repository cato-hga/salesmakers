# == Schema Information
#
# Table name: device_states
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime
#  updated_at :datetime
#  locked     :boolean          default(FALSE)
#

class DeviceState < ActiveRecord::Base
  validates :name, presence: true, length: { minimum: 3 }, uniqueness: { case_sensitive: false}
  has_and_belongs_to_many :devices
  has_many :log_entries, as: :trackable, dependent: :destroy
  has_many :log_entries, as: :referenceable, dependent: :destroy



  default_scope { order :name }
end
