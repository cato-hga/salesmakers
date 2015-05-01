module Candidates::Variables

  private

  def get_create_variables
    @projects = Project.all
    @candidate_source = CandidateSource.find_by id: candidate_params[:candidate_source_id]
    @outsourced = CandidateSource.find_by name: 'Outsourced'
    @select_location = params[:select_location] == 'true' ? true : false
  end

  def get_hours_information
    if @candidate.person and @candidate_shifts.present?
      @candidate_total_hours = @candidate_shifts.sum(:hours).round(2)
      @candidate_hours_last_week = @candidate_shifts.where('date > ? ', Date.today - 7.days).sum(:hours).round(2)
      @last_shift_date = @candidate_shifts.last.date.strftime('%A, %b %e')
      if @candidate_shifts.last.location
        @last_shift_location = "##{@candidate_shifts.last.location.store_number}, #{@candidate_shifts.last.location.street_1}, #{@candidate_shifts.last.location.city}, #{@candidate_shifts.last.location.state}"
      else
        @last_shift_location = 'No Location Attached To Shift'
      end
    end
  end

  def get_show_variables
    @candidate_contacts = @candidate.candidate_contacts
    @log_entries = @candidate.related_log_entries.page(params[:log_entries_page]).per(10)
    @candidate_availability = @candidate.candidate_availability if @candidate.candidate_availability
    @candidate_shifts = Shift.where(person: @candidate.person).order(date: :desc) if @candidate.person
    @candidate_reconciliation = @candidate.candidate_reconciliations.any? ? @candidate.candidate_reconciliations.last : CandidateReconciliation.new

  end

  def get_suffixes_and_sources
    @sources = CandidateSource.where active: true
    @suffixes = ['', 'Jr.', 'Sr.', 'II', 'III', 'IV']
  end

  def get_candidate
    @candidate = Candidate.find params[:id]
  end
end
