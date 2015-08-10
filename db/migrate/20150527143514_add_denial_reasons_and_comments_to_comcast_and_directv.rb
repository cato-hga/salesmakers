class AddDenialReasonsAndCommentsToComcastAndDirecTV < ActiveRecord::Migration
  def change
    add_column :directv_customers, :directv_lead_dismissal_reason_id, :integer
    add_column :directv_customers, :dismissal_comment, :text
    add_column :comcast_customers, :comcast_lead_dismissal_reason_id, :integer
    add_column :comcast_customers, :dismissal_comment, :text
  end
end
