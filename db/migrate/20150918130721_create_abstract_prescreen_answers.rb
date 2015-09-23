class CreateAbstractPrescreenAnswers < ActiveRecord::Migration
  def change
    create_table :abstract_prescreen_answers do |t|
      t.integer :candidate_id, null: false
      t.integer :person_id, null: false
      t.integer :project_id, null: false
      t.json :answers, null: false

      t.timestamps null: false
    end
  end
end
