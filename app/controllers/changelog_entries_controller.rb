class ChangelogEntriesController < ApplicationController
  after_action :verify_authorized
  before_action :do_authorization
  before_action :chronic_time_zones

  def index
    @changelog_entries = ChangelogEntry.all.page
  end

  def new
    @changelog_entry = ChangelogEntry.new
  end

  def create
    @changelog_entry = ChangelogEntry.new changelog_entry_params
    released = params.require(:changelog_entry).permit(:released)[:released]
    chronic_time = Chronic.parse(released)
    adjusted_time = chronic_time.in_time_zone
    @changelog_entry.released = adjusted_time
    if @changelog_entry.save
      puts @changelog_entry.inspect
      redirect_to changelog_entries_path
    else
      render :new
    end
  end


  private

  def chronic_time_zones
    Chronic.time_class = Time.zone
  end

  def changelog_entry_params
    params.require(:changelog_entry).permit :department_id,
                                            :project_id,
                                            :all_hq,
                                            :all_field,
                                            :heading,
                                            :description
  end

  def do_authorization
    authorize ChangelogEntry.new
  end
end