class ConnectDatabaseConnection < ActiveRecord::Base
  def self.abstract_class?
    true
  end
end