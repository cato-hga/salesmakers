class RootRedirectsController < ApplicationController

  def incoming_redirect
    department = @current_person.position.department
    if department.name == 'Information Technology'
      redirect_to devices_path
    end
    if department.name == 'Comcast Retail Sales'
      redirect_to new_comcast_customer_path
    end
  end
end
