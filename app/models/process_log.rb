class ProcessLog < ActiveRecord::Base
  validates :process_class, presence: true
end