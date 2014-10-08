require 'performance_ranker'

class SalesPerformanceRank < ActiveRecord::Base

  belongs_to :rankable, polymorphic: true

  scope :today, -> {
    where("day = ? AND day_rank IS NOT NULL", Date.today).order(:day_rank)
  }

  scope :yesterday, -> {
    where("day = ? AND day_rank IS NOT NULL", Date.yesterday).order(:day_rank)
  }

  scope :this_week, -> {
    where("day = ? AND week_rank IS NOT NULL", Date.today).order(:week_rank)
  }

  scope :last_week, -> {
    where("day = ? AND week_rank IS NOT NULL", Date.today.end_of_week - 1.week).order(:week_rank)
  }

  scope :this_month, -> {
    where("day = ? AND month_rank IS NOT NULL", Date.today).order(:month_rank)
  }

  scope :last_month, -> {
    where("day = ? AND month_rank IS NOT NULL", Date.today.end_of_month - 1.month).order(:month_rank)
  }

  scope :for_project_people, ->(project) {
    where(rankable: project.active_people)
  }

  def name
    self.rankable.name
  end

  def self.rank_people_sales
    PerformanceRanker.rank_people_sales
  end

end
