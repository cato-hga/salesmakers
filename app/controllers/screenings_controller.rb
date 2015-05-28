class ScreeningsController < ApplicationController
  before_action :do_authorization
  before_action :verify_authorized
  before_action :set_person

  def edit
    @screening = @person.screening ? @person.screening : Screening.new
  end

  def update
    screens = Screening.where(person_id: @person.id)
    candidate = Candidate.find_by person_id: @person.id
    if screens
      for screen in screens do
        screen.delete
      end
    end
    @screening = Screening.new
    @screening.update sex_offender_check: screening_params[:sex_offender_check].to_i,
                      public_background_check: screening_params[:public_background_check].to_i,
                      private_background_check: screening_params[:private_background_check].to_i,
                      drug_screening: screening_params[:drug_screening].to_i,
                      person: @person
    if @screening.none_selected?
      flash[:error] = 'You must have selected that at least one phase has been initiated.'
      redirect_to edit_person_screening_path(@person) and return
    end
    if @screening.save
      @person.reload
      @current_person.log? 'screened', @person
      flash[:notice] = 'Screening results saved.'
      redirect_to people_path
      if candidate
        @current_person.log? 'screened', candidate if @screening.complete? or @screening.failed?
        candidate.reload
        unless candidate.active
          @current_person.log? 'screening_failed', candidate
          @current_person.log? 'screening_failed', @person
        end
      end
    else
      puts @screening.errors.full_messages.join(',')
      render :edit
    end
  end

  private

  def do_authorization
    authorize Screening.new
  end

  def set_person
    @person = Person.find params[:person_id]
  end

  def screening_params
    params.require(:screening).permit :sex_offender_check,
                                      :public_background_check,
                                      :private_background_check,
                                      :drug_screening
  end
end