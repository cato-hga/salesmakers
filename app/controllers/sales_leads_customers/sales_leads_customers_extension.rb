module SalesLeadsCustomersExtension

  def shared_index(client, type)
    policy = Object.const_get "#{client}#{type}"
    @search = policy_scope(policy).search(params[:q])
    instance_variable_set "@#{client.downcase}_#{type.downcase}s", @search.result.page(params[:page])
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