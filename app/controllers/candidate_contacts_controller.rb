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
      render text: @candidate_contact.id
    else
      render partial: 'shared/ajax_errors', locals: { object: @candidate_contact }, status: :bad_request
    end
  end

  def save_call_results
    @candidate = Candidate.find params[:candidate_id]
    @candidate_contact = CandidateContact.find params[:candidate_contact_id]
    if @candidate_contact and @candidate_contact.update call_results: params[:call_results]
      flash[:notice] = 'Call results successfully saved!'
      redirect_to candidate_path(@candidate)
    else
      flash[:error] = 'Could not save the call results, but saved the before-call notes.'
      redirect_to new_call_candidate_candidate_contacts_path(@candidate) and return
    end
  end

  private

  def candidate_contact_params
    params.require(:candidate_contact).permit :candidate_id, :inbound, :contact_method, :notes
  end

end