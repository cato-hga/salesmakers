class GlobalSearchController < ApplicationController
  def results
    @people = find_people
    @candidates = find_candidates
    @devices = find_devices
    @lines = find_lines
  end

  private

  def find_people
    @people_query = Person.solr_search do
      fulltext params[:global_search]
      paginate :page => params[:page], :per_page => 20
    end
    @people_query.results
  end

  def find_candidates
    return [] unless CandidatePolicy.new(@current_person, Candidate.new).index?
    @candidates_query = Candidate.solr_search do
      fulltext params[:global_search]
      paginate :page => params[:page], :per_page => 20
    end
    @candidates_query.results
  end

  def find_devices
    return [] unless DevicePolicy.new(@current_person, Device.new).index?
    @devices_query = Device.solr_search do
      fulltext params[:global_search]
      paginate :page => params[:page], :per_page => 20
    end
    @devices_query.results
  end

  def find_lines
    return [] unless LinePolicy.new(@current_person, Line.new).index?
    @lines_query = Line.solr_search do
      fulltext params[:global_search]
      paginate :page => params[:page], :per_page => 20
    end
    @lines_query.results
  end
end