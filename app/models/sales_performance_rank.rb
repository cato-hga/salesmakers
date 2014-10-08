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

  scope :for_project_areas, ->(project) {
    areas_without_children = Array.new
    areas = project.areas
    for area in areas do
      areas_without_children << area if area.is_childless? and not areas_without_children.include?(area)
    end
    areas = Area.where("id IN (#{areas_without_children.map(&:id).join(',')})")
    where(rankable: areas)
  }

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
