require 'csv'

module DirecTVCSVExtension
  def csv
    @search = policy_scope(controller_name.classify.constantize).search(params[:q])
    @results = @search.result
    respond_to do |format|
      format.html { redirect_to self.send((controller_name + '_path').to_sym) }
      format.csv do
        headers['Content-Disposition'] = "attachment; filename=\"#{controller_name}_#{date_time_string}.csv\""
        headers['Content-Type'] ||= 'text/csv'

      end
    end
  end
end