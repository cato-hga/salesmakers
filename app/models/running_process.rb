class RunningProcess < ActiveRecord::Base
  validates :name, presence: true

  def self.running! klass
    return unless Rails.env.production?
    RunningProcess.find_or_create_by name: klass.class.name
  end

  def self.running? klass
    return false unless Rails.env.production?
    !RunningProcess.where(name: klass.class.name).empty?
  end

  def self.shutdown! klass
    return unless Rails.env.production?
    processes = RunningProcess.where(name: klass.class.name)
    processes.first.destroy unless processes.empty?
  end
end
