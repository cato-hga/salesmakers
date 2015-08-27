class AddTrueToPersonAcknowledgedInVonageSale < ActiveRecord::Migration
  def change
    VonageSale.update_all person_acknowledged: true
  end
end
