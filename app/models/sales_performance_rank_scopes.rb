module SalesPerformanceRankScopes
  def set_scopes
    set_day_scopes
    set_week_scopes
    set_month_scopes
    set_project_scopes
  end

  def set_day_scopes
    scope :today, -> {
      where("day = ? AND day_rank IS NOT NULL", Date.today).order(:day_rank)
    }

    scope :yesterday, -> {
      where("day = ? AND day_rank IS NOT NULL", Date.yesterday).order(:day_rank)
    }
  end

  def set_week_scopes
    scope :this_week, -> {
      where("day = ? AND week_rank IS NOT NULL", Date.today).order(:week_rank)
    }

    scope :last_week, -> {
      where("day = ? AND week_rank IS NOT NULL", Date.today.end_of_week - 1.week).order(:week_rank)
    }
  end

  def set_month_scopes
    scope :this_month, -> {
      where("day = ? AND month_rank IS NOT NULL", Date.today).order(:month_rank)
    }

    scope :last_month, -> {
      where("day = ? AND month_rank IS NOT NULL", Date.today.end_of_month - 1.month).order(:month_rank)
    }
  end

  def set_project_scopes
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
  end
end