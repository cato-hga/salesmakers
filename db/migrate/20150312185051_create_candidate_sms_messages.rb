class CreateCandidateSMSMessages < ActiveRecord::Migration
  def change
    create_table :candidate_sms_messages do |t|
      t.string :text, null: false
      t.boolean :active, null: false, default: true

      t.timestamps null: false
    end
  end
end
