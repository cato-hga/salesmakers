module Candidates::Variables

  private

  def get_create_variables
    @projects = Project.all
    @candidate_source = []
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
        location = @candidate_shifts.last.location
        @last_shift_location = "##{location.store_number} (#{location.channel.name}), #{location.street_1}, #{location.city}, #{location.state}"
      else
        @last_shift_location = 'No Location Attached To Shift'
      end
    end
  end

  def get_show_variables
    @candidate_contacts = @candidate.candidate_contacts
    @communication_log_entries = @candidate.communication_log_entries.page(params[:communication_log_entries_page]).per(10)
    @log_entries = @candidate.related_log_entries.page(params[:log_entries_page]).per(10)
    @candidate_availability = @candidate.candidate_availability if @candidate.candidate_availability
    @candidate_shifts = Shift.where(person: @candidate.person).order(date: :asc) if @candidate.person
    @candidate_reconciliation = @candidate.candidate_reconciliations.any? ? @candidate.candidate_reconciliations.last : CandidateReconciliation.new
    @candidate_notes = @candidate.candidate_notes
    @candidate_note = CandidateNote.new
  end

  def get_suffixes_and_sources
    @sources = []
    @vip = CandidateSource.find_by name: 'Project VIP'
    permission = Permission.find_by key: 'candidate_vip'
    for source in CandidateSource.all
      next if source == @vip unless @current_person.position.permissions.include? permission
      @sources << source if source.active
    end
    #@sources = CandidateSource.where active: true
    @suffixes = ['', 'Jr.', 'Sr.', 'II', 'III', 'IV']
  end

  def get_candidate
    @candidate = Candidate.find params[:id]
  end
end
