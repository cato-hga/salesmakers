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
    if department.name == 'DirecTV Retail Sales'
      redirect_to new_directv_customer_path and return
    end
    if department.name == 'Vonage Sales' or
        department.name == 'Vonage Event Sales'
      # TODO: redirect_to new_vonage_sale_path and return
      redirect_to vcp07012015_path(@current_person) and return
    end
    # TODO: redirect to new sales paths once Sprint migration complete
    # prepaid = Project.find_by(name: 'Sprint Prepaid')
    # if department.name == 'Sprint Prepaid Sales'
    #   redirect_to new_sprint_sales_path(prepaid) and return
    # end
    # star = Project.find_by(name: 'STAR')
    # if department.name == 'STAR Sales'
    #   redirect_to new_sprint_sales_path(star) and return
    # end
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
