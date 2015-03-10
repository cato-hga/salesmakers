class CreateJobOfferDetails < ActiveRecord::Migration
  def change
    create_table :job_offer_details do |t|
      t.integer :candidate_id, null: false
      t.datetime :sent, null: false
      t.datetime :completed

      t.timestamps null: false
    end
  end
end
