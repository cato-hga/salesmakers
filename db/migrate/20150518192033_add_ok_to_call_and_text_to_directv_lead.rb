class AddOkToCallAndTextToDirecTVLead < ActiveRecord::Migration
  def change
    add_column :directv_leads, :ok_to_call_and_text, :boolean
  end
end
