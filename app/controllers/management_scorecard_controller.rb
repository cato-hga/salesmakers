class ManagementScorecardController < ApplicationController
  after_action :verify_authorized
  after_action :verify_policy_scoped

  def management_scorecard
    authorize Area.new
    @area = policy_scope(Area).find params[:id]
    @people = @area.
        all_people.
        joins("left outer join shifts on shifts.person_id = people.id").
        where("people.active = true AND shifts.date >= ?", Date.today.beginning_of_week - 3.weeks).
        distinct.
        includes(:most_recent_employment)
    @weeks = [
        ['This Week', Date.today.beginning_of_week, Date.today, 'this_week'],
        ['Last Week', Date.today.beginning_of_week - 1.week, Date.today.beginning_of_week - 1.day, 'last_week'],
        ['2 Weeks Ago', Date.today.beginning_of_week - 2.weeks, Date.today.beginning_of_week - 1.day - 1.week, 'two_weeks_ago'],
        ['3 Weeks Ago', Date.today.beginning_of_week - 3.weeks, Date.today.beginning_of_week - 1.day - 2.weeks, 'three_weeks_ago']
    ]
  end
end
