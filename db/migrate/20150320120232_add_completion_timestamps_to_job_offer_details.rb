class AddCompletionTimestampsToJobOfferDetails < ActiveRecord::Migration
  def change
    add_column :job_offer_details, :completed_by_candidate, :datetime
    add_column :job_offer_details, :completed_by_advocate, :datetime
  end
end
