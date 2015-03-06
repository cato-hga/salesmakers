class AddEnvelopeGuidToJobOfferDetail < ActiveRecord::Migration
  def change
    add_column :job_offer_details, :envelope_guid, :string
  end
end
