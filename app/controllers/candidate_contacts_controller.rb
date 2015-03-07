class CandidateContactsController < ApplicationController
  layout false, only: [:create]

  def new_call
    @candidate = Candidate.find params[:candidate_id]
    @candidate_contact = CandidateContact.new candidate: @candidate,
                                              contact_method: :phone
  end

  def create
    @candidate = Candidate.find params[:candidate_id]
    @candidate_contact = CandidateContact.new candidate_contact_params.merge(person: @current_person, candidate: @candidate)
    if @candidate_contact.save
      render nothing: true
    else
      render partial: 'shared/ajax_errors', locals: { object: @candidate_contact }, status: :bad_request
    end
  end

  private

  def candidate_contact_params
    params.require(:candidate_contact).permit :candidate_id, :inbound, :contact_method, :notes
  end

end