class AddManagerAndThirdPartyToDocusignNos < ActiveRecord::Migration
  def change
    add_column :docusign_noses, :third_party, :boolean, null: false, default: false
    add_column :docusign_noses, :manager_id, :integer
  end
end
