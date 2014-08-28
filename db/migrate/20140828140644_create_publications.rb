class CreatePublications < ActiveRecord::Migration
  def change
    create_table :publications do |t|
      t.references :publishable, polymorphic: true, null: false
      t.timestamps
    end
  end
end
