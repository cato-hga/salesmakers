# == Schema Information
#
# Table name: running_processes
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class RunningProcess < ActiveRecord::Base
  validates :name, presence: true

  def self.running! klass
    RunningProcess.find_or_create_by name: klass.class.name
  end

  def self.running? klass
    !RunningProcess.where(name: klass.class.name).empty?
  end

  def self.shutdown! klass
    processes = RunningProcess.where(name: klass.class.name)
    processes.first.destroy unless processes.empty?
  end
end
