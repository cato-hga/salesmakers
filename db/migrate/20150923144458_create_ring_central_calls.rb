class CreateRingCentralCalls < ActiveRecord::Migration
  def change
    create_table :ring_central_calls do |t|
      t.string :ring_central_call_num, null: false
      t.json :json, null: false

      t.timestamps null: false
    end
  end
end
