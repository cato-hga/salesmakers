module Candidates::Locations
  def select_location
    all_location_areas = LocationArea.get_all_location_areas(@candidate, @current_person)
    @location_area_search = all_location_areas.search(params[:q])
    @location_areas = order_by_distance(@location_area_search.result)
    @candidate.assign_potential_territory(@location_areas)
    @back_to_confirm = params[:back_to_confirm] == 'true' ? true : false
  end

  def set_location_area
    @location_area = LocationArea.find params[:location_area_id]
    @back_to_confirm = params[:back_to_confirm] == 'true' ? true : false
    @previous_location_area = @candidate.location_area
    if @candidate.update location_area: @location_area
      handle_location_area
    else
      flash[:error] = @candidate.errors.full_messages.join(', ')
      redirect_to select_location_candidate_path(@candidate, @back_to_confirm.to_s)
    end
  end

  private

  def handle_location_area
    if @previous_location_area
      candidate_has_previous_location_area
    end
    if @location_area.outsourced?
      candidate_location_outsourced and return
    end
    if @back_to_confirm
      back_to_confirmation and return
    else
      candidate_location_completion
    end
  end

  def handle_outsourced
    if @candidate.save
      @current_person.log? 'create',
                           @candidate
      flash[:notice] = 'Outsourced candidate saved!'
      redirect_to select_location_candidate_path(@candidate, 'false')
    else
      render :new
    end
  end

  def candidate_has_previous_location_area
    @previous_location_area.update potential_candidate_count: @previous_location_area.potential_candidate_count - 1
    if Candidate.statuses[@candidate.status] >= Candidate.statuses['accepted']
      @previous_location_area.update offer_extended_count: @previous_location_area.offer_extended_count - 1
    end
  end

  def candidate_location_outsourced
    @candidate.accepted!
    @location_area.update potential_candidate_count: @location_area.potential_candidate_count + 1
    @location_area.update offer_extended_count: @location_area.offer_extended_count + 1
    flash[:notice] = 'Location chosen successfully.'
    redirect_to new_candidate_training_availability_path(@candidate)
  end

  def candidate_is_prescreened
    @location_area.update potential_candidate_count: @location_area.potential_candidate_count + 1
    flash[:notice] = 'Location chosen successfully. You were redirected to the candidate page because the candidate was already prescreened'
    redirect_to candidate_path(@candidate)
  end

  def back_to_confirm
    flash[:notice] = 'Location chosen successfully.'
    redirect_to (new_candidate_training_availability_path(@candidate))
  end

  def candidate_location_completion
    CandidatePrescreenAssessmentMailer.assessment_mailer(@candidate, @location_area.area).deliver_later
    @current_person.log? 'sent_assessment',
                         @candidate
    if @candidate.prescreened?
      candidate_is_prescreened and return
    else
      @candidate.location_selected! if @candidate.status == 'entered'
      flash[:notice] = 'Location chosen successfully.'
      redirect_to new_candidate_prescreen_answer_path(@candidate)
    end
  end
end