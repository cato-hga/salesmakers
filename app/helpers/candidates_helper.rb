module CandidatesHelper

  def cache_key_for_candidate(candidate)
    key = 'candidate-' + candidate.id.to_s + '-' + candidate.updated_at.try(:utc).try(:to_s, :number)
    key += "-#{@current_person.position.id.to_s}"
    key += '-' + max_updated(candidate.interview_schedules) unless candidate.interview_schedules.empty?
    key += '-' + candidate.person.screening.updated_at.try(:utc).try(:to_s, :number) if candidate.person and candidate.person.screening
    key += '-' + max_updated(candidate.candidate_reconciliations) unless candidate.candidate_reconciliations.empty?
    key + '-' + max_updated(SprintRadioShackTrainingSession) if SprintRadioShackTrainingSession.count > 0
  end

  private

  def max_updated(objs)
    objs.maximum(:updated_at).try(:utc).try(:to_s, :number)
  end
end
