class ProfileExperiencesController < ApplicationController
  def new
    person = Person.find params[:person_id]
    @profile_experience = ProfileExperience.new profile: person.profile
  end

  def edit
    @profile_experience = ProfileExperience.find params[:id]
  end

  def create
    @profile_experience = ProfileExperience.new profile_experience_params
    if @profile_experience.save
      flash[:notice] = 'Experience added.'
      redirect_to edit_person_profile_path(@profile_experience.profile.person, @profile_experience.profile)
    else
      render :new
    end
  end

  def update
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
                                               :profile_id
  end
end
