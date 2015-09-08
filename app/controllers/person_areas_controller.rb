class PersonAreasController < ApplicationController
  after_action :verify_authorized
  before_action :set_projects

  def index
    authorize PersonArea.new
    @person = Person.find params[:person_id]
    @person_areas = @person.person_areas.joins(:area).order('areas.name')
  end

  def new
    @person_area = PersonArea.new
    authorize @person_area
    @person = Person.find params[:person_id]
    @projects = Project.all.order(:name)
  end

  def create
    @person = Person.find params[:person_id]
    authorize PersonArea.new
    @person_area = PersonArea.new person_area_params
    @person_area.person = @person
    if @person_area.save
      @current_person.log? 'create',
                           @person_area,
                           @person
      flash[:notice] = 'Area saved successfully.'
      redirect_to person_person_areas_path(@person)
    else
      render :new
    end
  end

  def edit
    @person = Person.find params[:person_id]
    @person_area = PersonArea.find params[:id]
    authorize PersonArea.new
  end

  def update
    @person = Person.find params[:person_id]
    @person_area = PersonArea.find params[:id]
    authorize PersonArea.new
    @person_area.attributes = person_area_params
    @person_area.manages = false unless person_area_params[:manages]
    if @person_area.save
      @current_person.log? 'update',
                           @person_area,
                           @person
      flash[:notice] = 'Area saved successfully.'
      redirect_to person_person_areas_path(@person)
    else
      render :edit
    end
  end

  def destroy
    @person = Person.find params[:person_id]
    @person_area = PersonArea.find params[:id]
    area = @person_area.area
    authorize PersonArea.new
    if  @person_area.destroy
      @current_person.log? 'remove_area',
                           @person,
                           area
      flash[:notice] = 'Area successfully deleted.'
      redirect_to person_person_areas_path(@person)
    else
      flash[:error] = 'Could not delete the area.'
      redirect_to edit_person_person_area_path(@person, @person_area)
    end
  end

  private

  def person_area_params
    params.require(:person_area).permit :area_id, :manages
  end

  def set_projects
    @projects = Project.all
  end
end