module DirecTVCSVExtension
  def csv
    @search = policy_scope(controller_name.classify.constantize).search(params[:q])
    @results = @search.result
    respond_to do |format|
      format.html { redirect_to self.send((controller_name + '_path').to_sym) }
      format.csv do
        render csv: @results,
               filename: "#{controller_name}_#{date_time_string}",
               except: [
                   :id,
                   :directv_customer_id,
                   :created_at
               ],
               add_methods: [
                   :directv_customer_name,
                   :directv_customer_mobile_phone,
                   :directv_customer_other_phone
               ]
      end
    end
  end
end