class GlobalSearchController < ApplicationController
  def results
    items_array = ['people', 'candidates', 'devices', 'lines', 'location_areas']
    for item in items_array do
      item_class = item.classify
      object = Object.const_get(item_class)
      policy = item_class + 'Policy'
      policy_object = Object.const_get(policy)
      unless policy == 'PersonPolicy'
        return [] unless policy_object.new(@current_person, object.new).index?
      end
      query = object.solr_search do
        fulltext params[:global_search]
        paginate page: params[:page], per_page: 20
      end
      instance_variable_set "@#{item}_query", query
      instance_variable_set "@#{item}", query.results
      instance_variable_get "@#{item}"
      instance_variable_get "@#{item}_query"
    end
  end
end