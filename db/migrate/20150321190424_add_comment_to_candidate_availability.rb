class AddCommentToCandidateAvailability < ActiveRecord::Migration
  def change
    add_column :candidate_availabilities, :comment, :text
  end
end
