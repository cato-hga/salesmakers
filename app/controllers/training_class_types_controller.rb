class TrainingClassTypesController < ApplicationController
  before_action :do_authorization
  after_action :verify_authorized

  def index

  end

  def new
    @training_class_type = TrainingClassType.new
    @projects = Project.all
  end

  def create
    @training_class_type = TrainingClassType.new training_class_type_params
    @projects = Project.all
    if @training_class_type.save
      @current_person.log? 'create',
                           @training_class_type
      flash[:notice] = 'Training Class Type saved!'
      redirect_to training_class_types_path
    else
      flash[:error] = 'Training Class Type could not be saved'
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def training_class_type_params
    params.require(:training_class_type).permit(
        :name,
        :project_id,
        :max_attendance
    )
  end

  def do_authorization
    authorize TrainingClassType.new
  end
end