class AddNoteToShift < ActiveRecord::Migration
  def change
    add_column :shifts, :note, :string
  end
end
