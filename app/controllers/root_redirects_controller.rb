class RootRedirectsController < ApplicationController
  def incoming_redirect
    unless @current_person
      render file: 'public/403.html', status: :forbidden and return
    end
    department = @current_person.position.department
    if department.name == 'Information Technology'
      redirect_to devices_path and return
    end
    if department.name == 'Advocate Department' || department.name == 'Recruiting'
      redirect_to candidates_path and return
    end
    if department.name == 'Comcast Retail Sales'
      redirect_to new_comcast_customer_path and return
    end
    if department.name == 'Vonage Retail Sales' or
        department.name == 'Vonage Event Sales'
      redirect_to commission_person_path(@current_person) and return
    end
    if department.name == 'Executives'
      redirect_to people_path and return
    end
    if department.name == 'Human Resources'
      redirect_to devices_path and return
    end
    if department.name == 'Payroll'
      redirect_to devices_path and return
    end
  end

  def no_route
    unless request.fullpath.include?('/sales_charts/')
      raise ActionController::RoutingError.new("No route matches #{params[:unmatched_route]}")
    else
      render nothing: true
    end
  end
end
