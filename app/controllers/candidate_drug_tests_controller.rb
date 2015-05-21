class CandidateDrugTestsController < ApplicationController
  before_action :chronic_time_zones
  before_action :set_candidate
  def new
    @candidate_drug_test = CandidateDrugTest.new
  end

  def create
    if @candidate.candidate_drug_test.present?
      @candidate.candidate_drug_test.delete
    end
    @candidate_drug_test = CandidateDrugTest.new drug_test_params
    @candidate_drug_test.test_date = Chronic.parse params.require(:candidate_drug_test).permit(:test_date)[:test_date]
    @candidate_drug_test.candidate = @candidate
    if @candidate_drug_test.scheduled == true and (@candidate_drug_test.test_date == nil or @candidate_drug_test.test_date < Date.current)
      flash[:error] = 'The date entered could not be used - there may be a typo or invalid date. Please re-enter'
      render :new and return
    end
    if @candidate_drug_test.save
      if @candidate_drug_test.scheduled == true
        @current_person.log? 'has_scheduled_drug_test',
                             @candidate

      else
        @current_person.log? 'has_not_scheduled_drug_test',
                             @candidate
      end
      flash[:notice] = 'Drug Test information successfully updated'
      redirect_to candidates_path
    else
      flash[:error] = @candidate_drug_test.errors.full_messages.join(',')
      render :new
    end
  end

  private

  def drug_test_params
    params.require(:candidate_drug_test).permit :scheduled,
                                                :comments
  end

  def set_candidate
    @candidate = Candidate.find params[:candidate_id]
  end

  def chronic_time_zones
    Chronic.time_class = Time.zone
  end
end
