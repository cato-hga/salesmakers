# == Schema Information
#
# Table name: drop_off_reasons
#
#  id                      :integer          not null, primary key
#  name                    :string           not null
#  active                  :boolean          default(TRUE), not null
#  eligible_for_reschedule :boolean          default(TRUE), not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class DropOffReason < ActiveRecord::Base

  validates :name, presence: true
  validates :active, presence: true
  validates :eligible_for_reschedule, presence: true
end
