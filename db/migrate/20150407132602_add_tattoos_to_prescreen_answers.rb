class AddTattoosToPrescreenAnswers < ActiveRecord::Migration
  def change
    add_column :prescreen_answers, :visible_tattoos, :boolean, default: false, null: false
  end
end
