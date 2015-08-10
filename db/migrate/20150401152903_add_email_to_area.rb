class AddEmailToArea < ActiveRecord::Migration
  def change
    add_column :areas, :email, :string
  end
end
