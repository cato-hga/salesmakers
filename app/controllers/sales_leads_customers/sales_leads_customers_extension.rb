module SalesLeadsCustomersExtension

  def shared_index(client, type, order = nil)
    policy = Object.const_get "#{client}#{type}"
    if type == 'Lead'
      @search = policy_scope(policy).where(active: true).search(params[:q])
    else
      @search = policy_scope(policy).search(params[:q])
    end
    results = @search.result
    results = results.reorder(order) if order
    instance_variable_set "@#{client.downcase}_#{type.downcase}s", results.page(params[:page])
    authorize policy.new
  end

  def sale_create(client, sale, customer, path)
    parse_times(client.downcase)
    create_sale(client.downcase, sale, customer)
    if sale.save
      log 'create'
      flash[:notice] = 'Sale saved successfully.'
      redirect_to path and return
    else
      #Kicking back a flash message for incorrect dates
      incorrect_dates(sale)
      render :new and return
    end
  end

  def lead_create(client, lead, path)
    #The following section handle invalid Chronic dates, since we allow purposefully blank Follow Up Dates
    follow_up_by = params.require("#{client}_lead".to_sym).permit(:follow_up_by)[:follow_up_by]
    chronic_parse_follow_up_by = Chronic.parse follow_up_by
    Chronic.time_class = Time
    if follow_up_by.present? and chronic_parse_follow_up_by == nil
      flash[:error] = 'The date entered could not be used - there may be a typo or invalid date. Please re-enter'
      render :new and return
    else
      lead.follow_up_by = chronic_parse_follow_up_by
    end

    if lead.save
      @current_person.log? 'create',
                           lead,
                           @current_person,
                           nil,
                           nil,
                           params["#{client}_lead".to_sym][:comments]
      flash[:notice] = 'Lead saved successfully.'
      redirect_to path
    else
      render :new
    end
  end

  def lead_update(client, lead, path)
    lead.assign_attributes update_params
    lead.follow_up_by = Chronic.parse params.require("#{client}_lead".to_sym).permit(:follow_up_by)[:follow_up_by]
    if lead.save
      @current_person.log? 'update',
                           lead,
                           @current_person,
                           nil,
                           nil,
                           update_params[:comments]
      flash[:notice] = 'Lead updated successfully'
      redirect_to path
    else
      flash[:error] = 'Lead could not be updated'
      render :edit
    end

  end

  private

  def create_sale(client, sale, customer)
    sale.order_date = @sale_time.to_date if @sale_time
    #Yes, this sucks. Need to metaprogram the client into the attributes somehow, or remove the "comcast/direct" from the attribute names
    if client == 'comcast'
      sale.comcast_install_appointment.install_date = @install_time.to_date if @install_time
      sale.comcast_customer = customer
    else
      sale.directv_install_appointment.install_date = @install_time.to_date if @install_time
      sale.directv_customer = customer
    end
    sale.person = @current_person
  end


  def incorrect_dates(sale)
    if @sale_time == nil
      sale.errors.add :order_date, ' entered could not be used - there may be a typo or invalid date. Please re-enter'
    end
    if @install_time == nil
      sale.errors.add :install_date, ' entered could not be used - there may be a typo or invalid date. Please re-enter'
    end
  end

  def parse_times(client)
    Chronic.time_class = Time.zone
    @sale_time = Chronic.parse params.require("#{client}_sale".to_sym).permit(:order_date)[:order_date]
    @install_time = Chronic.parse params.require("#{client}_sale".to_sym).
                                      require("#{client}_install_appointment_attributes".to_sym).
                                      permit(:install_date)[:install_date]
    Chronic.time_class = Time
  end
end