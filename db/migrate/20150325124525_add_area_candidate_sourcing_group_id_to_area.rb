class AddAreaCandidateSourcingGroupIdToArea < ActiveRecord::Migration
  def change
    add_column :areas, :area_candidate_sourcing_group_id, :integer
  end
end
