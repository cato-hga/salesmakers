# == Schema Information
#
# Table name: process_logs
#
#  id                :integer          not null, primary key
#  process_class     :string           not null
#  records_processed :integer          default(0), not null
#  notes             :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class ProcessLog < ActiveRecord::Base
  validates :process_class, presence: true
end
