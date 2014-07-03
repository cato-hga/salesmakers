class LogEntriesController < ApplicationController
  def index
    @search = LogEntry.search(params[:q])
    @log_entries = @search.result.order('created_at DESC').page(params[:page])
  end
end
