# == Schema Information
#
# Table name: sales_performance_ranks
#
#  id            :integer          not null, primary key
#  day           :date             not null
#  rankable_id   :integer          not null
#  rankable_type :string           not null
#  day_rank      :integer
#  week_rank     :integer
#  month_rank    :integer
#  year_rank     :integer
#  created_at    :datetime
#  updated_at    :datetime
#

require 'performance_ranker'
require 'sales_performance_rank_scopes'

class SalesPerformanceRank < ActiveRecord::Base
  extend SalesPerformanceRankScopes

  belongs_to :rankable, polymorphic: true

  set_scopes

  def name
    self.rankable.name
  end

  def self.rank_people_sales automated = false
    PerformanceRanker.rank_sales 'Person', automated
  end

  def self.rank_areas_sales automated = false
    PerformanceRanker.rank_sales 'Area', automated
  end

end
