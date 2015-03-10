class CreateCandidateDenialReasons < ActiveRecord::Migration
  def change
    create_table :candidate_denial_reasons do |t|
      t.string :name, null: false
      t.boolean :active, default: true, null: false

      t.timestamps null: false
    end
  end
end
