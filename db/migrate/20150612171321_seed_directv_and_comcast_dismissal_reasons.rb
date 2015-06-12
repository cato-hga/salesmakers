class SeedDirecTVAndComcastDismissalReasons < ActiveRecord::Migration
  def change
    ComcastLeadDismissalReason.create name: 'Customer Cancelled', active: true
    ComcastLeadDismissalReason.create name: 'Customer Non-Responsive', active: true
    ComcastLeadDismissalReason.create name: 'Customer Awaiting Installation', active: true
    ComcastLeadDismissalReason.create name: 'Customer chose a different service', active: true
    ComcastLeadDismissalReason.create name: 'Customer had a high deposit', active: true
    ComcastLeadDismissalReason.create name: 'No Debit or Credit Card', active: true
    ComcastLeadDismissalReason.create name: 'Address Unservicable', active: true
    ComcastLeadDismissalReason.create name: 'House Debt/Deposit Issue', active: true
    DirecTVLeadDismissalReason.create name: 'Customer Cancelled', active: true
    DirecTVLeadDismissalReason.create name: 'Customer Non-Responsive', active: true
    DirecTVLeadDismissalReason.create name: 'Customer Awaiting Installation', active: true
    DirecTVLeadDismissalReason.create name: 'Customer chose a different service', active: true
    DirecTVLeadDismissalReason.create name: 'Customer had a high deposit', active: true
    DirecTVLeadDismissalReason.create name: 'No Debit or Credit Card', active: true
    DirecTVLeadDismissalReason.create name: 'Address Unservicable', active: true
    DirecTVLeadDismissalReason.create name: 'House Debt/Deposit Issue', active: true
  end
end
