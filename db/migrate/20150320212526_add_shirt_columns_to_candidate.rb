class AddShirtColumnsToCandidate < ActiveRecord::Migration
  def change
    add_column :candidates, :shirt_gender, :string
    add_column :candidates, :shirt_size, :string
  end
end
