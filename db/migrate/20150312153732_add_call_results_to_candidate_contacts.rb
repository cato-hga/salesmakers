class AddCallResultsToCandidateContacts < ActiveRecord::Migration
  def change
    add_column :candidate_contacts, :call_results, :text
  end
end
