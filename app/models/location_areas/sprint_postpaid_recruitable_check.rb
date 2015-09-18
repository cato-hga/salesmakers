class LocationAreas::SprintPostpaidRecruitableCheck

  def self.recruitable? location_area, padding
    return false unless location_area.priority
    return false unless (location_area.priority == 1 or location_area.priority == 2)
    candidates = location_area.candidates_in_funnel.count
    return true if candidates < location_area.target_head_count + padding
    false
  end

  def self.candidates_in_funnel location_area
    non_rejected_candidates_in_location_area = Candidate.
        all_active.
        where(location_area: location_area).
        where.not(sprint_roster_status: Candidate.sprint_roster_statuses[:sprint_rejected],
                  training_session_status: Candidate.inactive_training_session_statuses)
    candidates_in_training_ids = non_rejected_candidates_in_location_area.
        joins(:sprint_radio_shack_training_session).
        where("sprint_radio_shack_training_sessions.start_date > ?", Date.today).
        ids
    paperwork_sent_36_hours_ids = non_rejected_candidates_in_location_area.
        joins(:job_offer_details).
        where("job_offer_details.sent >= ?", DateTime.now - 36.hours).
        ids
    Candidate.where id: [candidates_in_training_ids, paperwork_sent_36_hours_ids].flatten.uniq
  end

end