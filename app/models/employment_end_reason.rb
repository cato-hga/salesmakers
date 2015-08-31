# == Schema Information
#
# Table name: employment_end_reasons
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  active     :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class EmploymentEndReason < ActiveRecord::Base
  strip_attributes
end
