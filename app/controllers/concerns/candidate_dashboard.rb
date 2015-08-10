module CandidateDashboard
  extend ActiveSupport::Concern

  def dashboard
    set_datetime_range
    set_dashboard_variables
    set_screening_check('sex_offender_check')
    set_screening_check('public_background_check')
    set_screening_check('private_background_check')
    set_screening_check('drug_screening')
    set_screened('partially_screened')
    set_screened('fully_screened')
  end

  private

  def set_datetime_range
    datetime_range = DateTime.now.in_time_zone + Time.zone.utc_offset + (DateTime.now.in_time_zone.dst? ? 3600 : 0)
    @datetime_start = datetime_range.beginning_of_day
    @datetime_end = datetime_range.end_of_day
  end

  def status_info
    [
        [
            :entered, nil, 'candidates.created_at', nil
        ],
        [
            :prescreened, :prescreen_answers, 'prescreen_answers.created_at', nil
        ],
        [
            :interview_scheduled, :interview_schedules, 'interview_schedules.created_at', nil
        ],
        [
            :accepted, :interview_answers, 'interview_answers.created_at', 'candidates.active = true'
        ],
        [
            :paperwork_sent, :job_offer_details, 'job_offer_details.sent', nil
        ],
        [
            :paperwork_completed_by_candidate, :job_offer_details, 'job_offer_details.completed_by_candidate', nil
        ],
        [
            :paperwork_completed_by_advocate, :job_offer_details, 'job_offer_details.completed_by_advocate', nil
        ],
        [
            :paperwork_completed_by_hr, :job_offer_details, 'job_offer_details.completed', nil
        ],
        [
            :onboarded, :person, 'people.created_at', nil
        ],
    ]
  end

  def set_dashboard_variables
    for status in status_info do
      range_info = range_scope status[2], status[1], status[3]
      total_info = Candidate.where(status: Candidate.statuses[status[0]].to_i, active: true)
      instance_variable_set "@#{status[0].to_s}_range", range_info
      instance_variable_set "@#{status[0].to_s}_total", total_info
      instance_variable_get "@#{status[0].to_s}_range"
      instance_variable_get "@#{status[0].to_s}_total"
    end

  end

  def range_scope(column, join_table = nil, extra_condition = nil)
    where_string = "#{column} >= CAST('#{@datetime_start.to_s}' AS TIMESTAMP) " +
        "AND #{column} <= CAST('#{@datetime_end.to_s}' AS TIMESTAMP)"
    where_string += " AND #{extra_condition}" if extra_condition
    range_scope = Candidate
    range_scope = range_scope.joins(join_table) if join_table
    range_scope.where(where_string)
  end

  def set_screened(status_string)
    self.instance_variable_set "@#{status_string}_range".to_sym,
                               Candidate.where(
                                   "status = ? AND updated_at >= ? AND updated_at <= ?",
                                   Candidate.statuses[status_string.to_sym].to_i,
                                   @datetime_start,
                                   @datetime_end
                               )
    self.instance_variable_set "@#{status_string}_total".to_sym,
                               Candidate.where(status: Candidate.statuses[status_string.to_sym].to_i,
                                               active: true)
  end

  def set_screening_check(type)
    instance_variable_set "@passed_#{type}_range", Candidate.joins('INNER JOIN people ON people.id = candidates.person_id ' +
                                                                       'LEFT OUTER JOIN screenings ON screenings.person_id = people.id').
                                                     where("candidates.status = ? AND screenings.updated_at >= ? AND screenings.updated_at <= ? AND screenings.#{type} = ?",
                                                           Candidate.statuses[:partially_screened].to_i,
                                                           @datetime_start,
                                                           @datetime_end,
                                                           Screening.send("#{type}s")["#{type}_passed".to_sym]
                                                     )
    instance_variable_set "@passed_#{type}_total", Candidate.joins('INNER JOIN people ON people.id = candidates.person_id ' +
                                                                       'LEFT OUTER JOIN screenings ON screenings.person_id = people.id').
                                                     where("candidates.active = true AND candidates.status = ? AND screenings.#{type} = ?",
                                                           Candidate.statuses[:partially_screened].to_i,
                                                           Screening.send("#{type}s")["#{type}_passed".to_sym].to_i
                                                     )
  end
end