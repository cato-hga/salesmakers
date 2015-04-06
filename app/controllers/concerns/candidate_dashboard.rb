module CandidateDashboard
  extend ActiveSupport::Concern

  protected

  def set_datetime_range
    datetime_range = DateTime.now.in_time_zone + Time.zone.utc_offset + (DateTime.now.in_time_zone.dst? ? 3600 : 0)
    @datetime_start = datetime_range.beginning_of_day
    @datetime_end = datetime_range.end_of_day
  end

  def set_entered
    @entered_range = Candidate.where(
        "created_at >= ? AND created_at <= ?",
        @datetime_start,
        @datetime_end
    )
    @entered_total = Candidate.where(status: Candidate.statuses[:entered].to_i, active: true)
  end

  def set_prescreened
    @prescreened_range = Candidate.
        joins(:prescreen_answers).
        where("prescreen_answers.created_at >= ? AND prescreen_answers.created_at <= ?",
              @datetime_start,
              @datetime_end)
    @prescreened_total = Candidate.where(status: Candidate.statuses[:prescreened].to_i, active: true)
  end

  def set_interview_scheduled
    @interview_scheduled_range = Candidate.
        joins(:interview_schedules).
        where("interview_schedules.created_at >= ? AND interview_schedules.created_at <= ?",
              @datetime_start,
              @datetime_end)
    @interview_scheduled_total = Candidate.where(status: Candidate.statuses[:interview_scheduled].to_i, active: true)
  end

  def set_accepted
    @accepted_range = Candidate.
        joins(:interview_answers).
        where("interview_answers.created_at >= ? AND interview_answers.created_at <= ? AND candidates.active = true",
              @datetime_start,
              @datetime_end)
    @accepted_total = Candidate.where(status: Candidate.statuses[:accepted].to_i, active: true)
  end

  def set_paperwork_sent
    @paperwork_sent_range = Candidate.
        joins(:job_offer_details).
        where("job_offer_details.sent >= ? AND job_offer_details.sent <= ?",
              @datetime_start,
              @datetime_end)
    @paperwork_sent_total = Candidate.where(status: Candidate.statuses[:paperwork_sent].to_i, active: true)
  end

  def set_paperwork_completed_by_candidate
    @paperwork_completed_by_candidate_range = Candidate.
        joins(:job_offer_details).
        where("job_offer_details.completed_by_candidate >= ? AND job_offer_details.completed_by_candidate <= ?",
              @datetime_start,
              @datetime_end)
    @paperwork_completed_by_candidate_total = Candidate.where(status: Candidate.statuses[:paperwork_completed_by_candidate].to_i, active: true)
  end

  def set_paperwork_completed_by_advocate
    @paperwork_completed_by_advocate_range = Candidate.
        joins(:job_offer_details).
        where("job_offer_details.completed_by_advocate >= ? AND job_offer_details.completed_by_advocate <= ?",
              @datetime_start,
              @datetime_end)
    @paperwork_completed_by_advocate_total = Candidate.where(status: Candidate.statuses[:paperwork_completed_by_advocate].to_i, active: true)
  end

  def set_paperwork_completed_by_hr
    @paperwork_completed_by_hr_range = Candidate.
        joins(:job_offer_details).
        where("job_offer_details.completed >= ? AND job_offer_details.completed <= ?",
              @datetime_start,
              @datetime_end)
    @paperwork_completed_by_hr_total = Candidate.where(status: Candidate.statuses[:paperwork_completed_by_hr].to_i, active: true)
  end

  def set_onboarded
    @onboarded_range = Candidate.
        joins(:person).
        where(
            "people.created_at >= ? AND people.created_at <= ?",
            @datetime_start,
            @datetime_end
        )
    @onboarded_total = Candidate.where(status: Candidate.statuses[:onboarded].to_i, active: true)
  end

  def set_rejected
    @rejected_range = Candidate.where(
        "active = false AND updated_at >= ? AND updated_at <= ?",
        @datetime_start,
        @datetime_end
    )
    @rejected_total = Candidate.where(status: Candidate.statuses[:rejected].to_i)
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

  def set_passed_sex_offender_check
    @passed_sex_offender_check_range = Candidate.joins('INNER JOIN people ON people.id = candidates.person_id ' +
                                                           'LEFT OUTER JOIN screenings ON screenings.person_id = people.id').
        where("candidates.status = ? AND screenings.updated_at >= ? AND screenings.updated_at <= ? AND screenings.sex_offender_check = ?",
              Candidate.statuses[:partially_screened].to_i,
              @datetime_start,
              @datetime_end,
              Screening.sex_offender_checks[:sex_offender_check_passed]
        )
    @passed_sex_offender_check_total = Candidate.joins('INNER JOIN people ON people.id = candidates.person_id ' +
                                                           'LEFT OUTER JOIN screenings ON screenings.person_id = people.id').
        where("candidates.active = true AND candidates.status = ? AND screenings.sex_offender_check = ?",
              Candidate.statuses[:partially_screened].to_i,
              Screening.sex_offender_checks[:sex_offender_check_passed].to_i
        )
  end

  def set_passed_public_background_check
    @passed_public_background_check_range = Candidate.joins('INNER JOIN people ON people.id = candidates.person_id ' +
                                                                'LEFT OUTER JOIN screenings ON screenings.person_id = people.id').
        where("candidates.status = ? AND screenings.updated_at >= ? AND screenings.updated_at <= ? AND screenings.public_background_check = ?",
              Candidate.statuses[:partially_screened].to_i,
              @datetime_start,
              @datetime_end,
              Screening.public_background_checks[:public_background_check_passed]
        )
    @passed_public_background_check_total = Candidate.joins('INNER JOIN people ON people.id = candidates.person_id ' +
                                                                'LEFT OUTER JOIN screenings ON screenings.person_id = people.id').
        where("candidates.active = true AND candidates.status = ? AND screenings.public_background_check = ?",
              Candidate.statuses[:partially_screened].to_i,
              Screening.public_background_checks[:public_background_check_passed].to_i
        )
  end

  def set_passed_private_background_check
    @passed_private_background_check_range = Candidate.joins('INNER JOIN people ON people.id = candidates.person_id ' +
                                                                 'LEFT OUTER JOIN screenings ON screenings.person_id = people.id').
        where("candidates.status = ? AND screenings.updated_at >= ? AND screenings.updated_at <= ? AND screenings.private_background_check = ?",
              Candidate.statuses[:partially_screened].to_i,
              @datetime_start,
              @datetime_end,
              Screening.private_background_checks[:private_background_check_passed]
        )
    @passed_private_background_check_total = Candidate.joins('INNER JOIN people ON people.id = candidates.person_id ' +
                                                                 'LEFT OUTER JOIN screenings ON screenings.person_id = people.id').
        where("candidates.active = true AND candidates.status = ? AND screenings.private_background_check = ?",
              Candidate.statuses[:partially_screened].to_i,
              Screening.private_background_checks[:private_background_check_passed].to_i
        )
  end

  def set_passed_drug_screening
    @passed_drug_screening_range = Candidate.joins('INNER JOIN people ON people.id = candidates.person_id ' +
                                                       'LEFT OUTER JOIN screenings ON screenings.person_id = people.id').
        where("candidates.status = ? AND screenings.updated_at >= ? AND screenings.updated_at <= ? AND screenings.drug_screening = ?",
              Candidate.statuses[:partially_screened].to_i,
              @datetime_start,
              @datetime_end,
              Screening.drug_screenings[:drug_screening_passed]
        )
    @passed_drug_screening_total = Candidate.joins('INNER JOIN people ON people.id = candidates.person_id ' +
                                                       'LEFT OUTER JOIN screenings ON screenings.person_id = people.id').
        where("candidates.active = true AND candidates.status = ? AND screenings.drug_screening = ?",
              Candidate.statuses[:partially_screened].to_i,
              Screening.drug_screenings[:drug_screening_passed].to_i
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