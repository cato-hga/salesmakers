class SalesPerformanceRank < ActiveRecord::Base

  belongs_to :rankable, polymorphic: true
end
