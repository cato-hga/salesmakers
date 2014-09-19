class ProfilesController < ProtectedController

  def edit
    @profile = Profile.find params[:id]
    @person = @profile.person
    @profile_experiences = ProfileExperience.where profile: @profile
    @profile_skills = ProfileSkill.where profile: @profile
    @profile_educations = ProfileEducation.where profile: @profile
    authorize @profile
    @themes = Theme.all
  end

  def update
    @profile = Profile.find params[:id]
    person = @profile.person
    authorize @profile
    if @profile.update_attributes profile_params
      flash[:notice] = 'Profile saved.'
      redirect_to person
    else
      render :edit
    end
  end

  private







  def profile_params
    params.require(:profile).permit(:bio, :nickname)
  end
end
