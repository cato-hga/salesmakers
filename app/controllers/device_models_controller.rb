class DeviceModelsController < ApplicationController

  def index
    #authorize DeviceModel.new
    #@search = policy_scope(DeviceModel).search(params[:q])
    @search = DeviceModel.search(params[:q])
    @device_models = @search.result.order('name').page(params[:page])
  end

  def new
    models = DeviceModel.all
    manufacturers = Array.new
    for model in models do
      manufacturers << model.device_manufacturer
    end
    @device_manufacturers = manufacturers
    @device_model = DeviceModel.new
  end

  def create
    @device_model = DeviceModel.new create_params
    if @device_model.save
      @current_person.log? 'create', @device_model
      flash[:notice] = 'Device model created!'
      redirect_to device_models_path
    else
      render :new
    end
  end

  def edit
    @device_model = DeviceModel.find params[:id]
  end

  def update
    @device_model = DeviceModel.find params[:id]
    if @device_model.update update_params
      @current_person.log? 'edit', @device_model
      redirect_to device_models_path
    else
      render :edit
    end
  end

  private

  def create_params
    params.require(:device_model).permit(:device_manufacturer_id, :name)
  end

  def update_params
    params.require(:device_model).permit(:device_manufacturer_id, :name)
  end
end