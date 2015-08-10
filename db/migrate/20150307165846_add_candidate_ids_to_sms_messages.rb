class AddCandidateIdsToSMSMessages < ActiveRecord::Migration
  def change
    add_column :sms_messages, :from_candidate_id, :integer
    add_column :sms_messages, :to_candidate_id, :integer
  end
end
