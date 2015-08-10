class AddSubjectToEmailMessage < ActiveRecord::Migration
  def change
    add_column :email_messages, :subject, :string, null: false
  end
end
