class CreateVonageMacPrefixes < ActiveRecord::Migration
  def change
    create_table :vonage_mac_prefixes do |t|
      t.string :prefix, null: false

      t.timestamps null: false
    end
  end
end
