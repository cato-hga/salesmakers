class AddDefaultTrueToCandidateSource < ActiveRecord::Migration
  def change
    change_column :candidate_sources, :name, :string, null: false
    change_column :candidate_sources, :active, :boolean, default: true, null: false
  end
end
