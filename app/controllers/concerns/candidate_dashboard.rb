module CandidateDashboard
  extend ActiveSupport::Concern

  protected

  def set_datetime_range
    datetime_range = DateTime.now.in_time_zone + Time.zone.utc_offset + (DateTime.now.in_time_zone.dst? ? 3600 : 0)
    @datetime_start = datetime_range.beginning_of_day
    @datetime_end = datetime_range.end_of_day
  end

  def status_info
    [
        [
            :entered, nil, nil, nil
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
      if status[1].present? and status[2].present?
        range_info = Candidate.
            joins(status[1]).
            where("#{status[2]} >= ? AND #{status[2]} <= ?",
                  @datetime_start,
                  @datetime_end
            )
      elsif status[3].present?
        range_info = Candidate.
            joins(:interview_answers).
            where("#{status[2]} >= ? AND #{status[2]} <= ? AND #{status[3]}",
                  @datetime_start,
                  @datetime_end)
      else
        range_info = Candidate.where(
            "created_at >= ? AND created_at <= ?",
            @datetime_start,
            @datetime_end
        )
      end
      total_info = Candidate.where(status: Candidate.statuses[status[0]].to_i, active: true)
      instance_variable_set "@#{status[0].to_s}_range", range_info
      instance_variable_set "@#{status[0].to_s}_total", total_info
      instance_variable_get "@#{status[0].to_s}_range"
      instance_variable_get "@#{status[0].to_s}_total"
    end

  end

  def set_partially_screened
    @partially_screened_range = Candidate.where(
        "status = ? AND updated_at >= ? AND updated_at <= ?",
        Candidate.statuses[:partially_screened].to_i,
        @datetime_start,
        @datetime_end
    )
    @partially_screened_total = Candidate.where(status: Candidate.statuses[:partially_screened].to_i, active: true)
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

  def set_fully_screened
    @fully_screened_range = Candidate.where(
        "status = ? AND updated_at >= ? AND updated_at <= ?",
        Candidate.statuses[:fully_screened].to_i,
        @datetime_start,
        @datetime_end
    )
    @fully_screened_total = Candidate.where(status: Candidate.statuses[:fully_screened].to_i, active: true)
  end
end