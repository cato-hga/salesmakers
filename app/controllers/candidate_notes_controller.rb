class CandidateNotesController < ApplicationController

  def create
    candidate = Candidate.find params[:candidate_id]
    note = params.require(:candidate_note).permit(:note)[:note]
    candidate_note = CandidateNote.new candidate: candidate,
                                       person: @current_person,
                                       note: note
    if candidate_note.save
      flash[:notice] = 'Note was saved successfully.'
    else
      flash[:error] = candidate_note.errors.full_messages.join(', ')
    end
    redirect_to candidate_path(candidate)
  end

end