module SalesLeadsCustomersExtension

  def shared_index(client, type)
    policy = Object.const_get "#{client}#{type}"
    @search = policy_scope(policy).search(params[:q])
    instance_variable_set "@#{client.downcase}_#{type.downcase}s", @search.result.page(params[:page])
    authorize policy.new
  end

  private

  def parse_times(client)
    Chronic.time_class = Time.zone
    @sale_time = Chronic.parse params.require("#{client}_sale".to_sym).permit(:order_date)[:order_date]
    @install_time = Chronic.parse params.require("#{client}_sale".to_sym).
                                      require("#{client}_install_appointment_attributes".to_sym).
                                      permit(:install_date)[:install_date]
    Chronic.time_class = Time
  end
end