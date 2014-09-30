class ProfileExperiencesController < ApplicationController
  def new
    person = @current_person
    @profile_experience = ProfileExperience.new profile: person.profile
  end

  def edit
    @profile_experience = ProfileExperience.find params[:id]
  end

  def create
    @profile_experience = ProfileExperience.new profile_experience_params
    @profile_experience.ended = nil if @profile_experience.currently_employed?
    if @profile_experience.save
      flash[:notice] = 'Experience added.'
      redirect_to edit_profile_path(@profile_experience.profile)
    else
      render :new
    end
  end

  def update
    @profile_experience = ProfileExperience.find params[:id]
    if @profile_experience.update profile_experience_params
      flash[:notice] = 'Changes saved.'
      redirect_to edit_profile_path(@profile_experience.profile)
    else
      render :edit
    end
  end

  def destroy
  end

  private

  def profile_experience_params
    params.require(:profile_experience).permit :title,
                                               :company_name,
                                               :started,
                                               :ended,
                                               :location,
                                               :description,
                                               :profile_id,
                                               :currently_employed
  end
end
