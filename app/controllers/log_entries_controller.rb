class LogEntriesController < ProtectedController
  def index
    authorize LogEntry.new
    @search = policy_scope(LogEntry).search(params[:q])
    @log_entries = @search.result.order('created_at DESC').page(params[:page])
  end
end
