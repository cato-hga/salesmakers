# == Schema Information
#
# Table name: line_states
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime
#  updated_at :datetime
#  locked     :boolean          default(FALSE)
#

class LineState < ActiveRecord::Base
  validates :name, presence: true, length: { minimum: 3 }, uniqueness: { case_sensitive: false }

  has_and_belongs_to_many :lines

  default_scope { order :name }

  strip_attributes
end
