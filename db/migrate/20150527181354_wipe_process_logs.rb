class WipeProcessLogs < ActiveRecord::Migration
  def self.up
    ProcessLog.destroy_all
  end
end
