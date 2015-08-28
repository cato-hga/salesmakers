# == Schema Information
#
# Table name: vonage_mac_prefixes
#
#  id         :integer          not null, primary key
#  prefix     :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class VonageMacPrefix < ActiveRecord::Base
  before_save :uppercase

  validates :prefix, length: { is: 6 }

  private

  def uppercase
    self.prefix = self.prefix.upcase
  end
end
