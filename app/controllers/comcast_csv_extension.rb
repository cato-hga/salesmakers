module ComcastCSVExtension
  def csv
    @search = policy_scope(controller_name.classify.constantize).search(params[:q])
    @results = @search.result
    respond_to do |format|
      format.html { redirect_to self.send((controller_name + '_path').to_sym) }
      format.csv do
        methods = [
            :entered_by_name,
            :comcast_customer_name,
            :comcast_customer_mobile_phone,
            :comcast_customer_other_phone,
            :rgus,
            :link
        ]
        methods << :converted_to_sale if controller_name == 'comcast_leads'
        render csv: @results,
               filename: "#{controller_name}_#{date_time_string}",
               except: [
                   :id,
                   :comcast_customer_id,
                   :created_at
               ],
               add_methods: methods
      end
    end
  end
end