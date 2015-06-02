class SMSDailyChecksController < ApplicationController

  after_action :verify_authorized

  def index
    authorize SMSDailyCheck.new
  end
end
