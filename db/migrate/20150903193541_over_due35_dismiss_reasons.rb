class OverDue35DismissReasons < ActiveRecord::Migration
  def change
    ComcastLeadDismissalReason.create name: '35 days without follow up',
                                      active: true
    DirecTVLeadDismissalReason.create name: '35 days without follow up',
                                      active: true
  end
end
