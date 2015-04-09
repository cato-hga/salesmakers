class CandidateDrugTestsController < ApplicationController
  def new
    @candidate = Candidate.find params[:candidate_id]
    @candidate_drug_test = CandidateDrugTest.new
  end

  def create
    @candidate = Candidate.find params[:candidate_id]
    @candidate_drug_test = CandidateDrugTest.new drug_test_params
    @candidate_drug_test.candidate = @candidate
    if @candidate_drug_test.save
      if @candidate_drug_test.scheduled == false
        @current_person.log? 'has_not_scheduled_drug_test',
                             @candidate
      end
      flash[:notice] = 'Drug Test information successfully updated'
      redirect_to candidates_path
    end
  end

  def edit
  end

  def update
  end

  private

  def drug_test_params
    params.require(:candidate_drug_test).permit(:schedule,
                                                :comments,
                                                :test_date
    )
  end
end
