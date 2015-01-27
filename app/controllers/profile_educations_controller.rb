# class ProfileEducationsController < ApplicationController
#   def new
#     person = @current_person
#     @profile_education = ProfileEducation.new profile: person.profile
#   end
#
#   def edit
#     @profile_education = ProfileEducation.find params[:id]
#   end
#
#   def create
#     @profile_education = ProfileEducation.new profile_education_params
#     if @profile_education.save
#       flash[:notice] = 'Education added.'
#       redirect_to edit_profile_path(@profile_education.profile)
#     else
#       render :new
#     end
#   end
#
#   def update
#     @profile_education = ProfileEducation.find params[:id]
#     if @profile_education.update profile_education_params
#       flash[:notice] = 'Changes saved.'
#       redirect_to edit_profile_path(@profile_education.profile)
#     else
#       render :edit
#     end
#   end
#
#   def destroy
#     @profile_education = ProfileEducation.find params[:id]
#     if @profile_education.destroy
#       flash[:notice] = 'Education deleted!'
#       redirect_to :back
#     else
#       flash[:error] = 'Could not delete Education!'
#     end
#   end
#
#   private
#
#   def profile_education_params
#     params.require(:profile_education).permit :school,
#                                               :degree,
#                                               :start_year,
#                                               :end_year,
#                                               :field_of_study,
#                                               :description,
#                                               :profile_id,
#                                               :activities_societies
#   end
# end
