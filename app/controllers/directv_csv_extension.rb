require 'csv'

module DirecTVCSVExtension
  def csv
    @search = policy_scope(controller_name.classify.constantize).search(params[:q])
    @results = @search.result
    handle_csv controller_name
  end
end