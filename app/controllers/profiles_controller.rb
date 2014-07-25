class ProfilesController < ApplicationController
  def edit
    person = Person.find params[:person_id]
    @profile = Profile.find_by person: person
    @themes = Theme.all
  end

  def update
    person = Person.find params[:person_id]
    @profile = Profile.find_by person: person
    if @profile.update_attributes profile_params
      flash[:notice] = 'Profile saved.'
      redirect_to root_path
    else
      render :edit
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:theme_name)
  end
end
