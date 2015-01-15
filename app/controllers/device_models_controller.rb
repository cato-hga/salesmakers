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
    @model = DeviceModel.new create_params
    if @model.save
      @current_person.log? 'create', @model
      redirect_to device_models_path
    end
  end

  private

  def create_params
    params.permit :device_manufacturer_id, :name
  end
end