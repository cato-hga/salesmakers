class API::BaseController < ApplicationController
  before_action :check_ip
  respond_to :json
  layout false

  def check_ip
    if request.remote_ip != '184.106.187.251'
      render file: "public/401.html", status: :unauthorized
    end
  end
end