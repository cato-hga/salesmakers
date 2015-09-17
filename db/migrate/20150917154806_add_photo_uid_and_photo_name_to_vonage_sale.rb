class AddPhotoUidAndPhotoNameToVonageSale < ActiveRecord::Migration
  def change
    add_column :vonage_sales, :photo_uid, :string
    add_column :vonage_sales, :photo_name, :string
  end
end
