class TrainingClassTypesController < ApplicationController
  before_action :do_authorization
  after_action :verify_authorized

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def do_authorization
    authorize TrainingClassType.new
  end
end