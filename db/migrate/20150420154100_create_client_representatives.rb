class CreateClientRepresentatives < ActiveRecord::Migration
  def change
    create_table :client_representatives do |t|
      t.integer :client_id, null: false
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false

      t.timestamps null: false
    end
  end
end
