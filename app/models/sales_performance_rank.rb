require 'performance_ranker'
require 'sales_performance_rank_scopes'

class SalesPerformanceRank < ActiveRecord::Base
  extend SalesPerformanceRankScopes

  belongs_to :rankable, polymorphic: true

  set_scopes

  def name
    self.rankable.name
  end

  def self.rank_people_sales
    PerformanceRanker.rank_people_sales
  end

  def self.rank_areas_sales
    PerformanceRanker.rank_areas_sales
  end

end
