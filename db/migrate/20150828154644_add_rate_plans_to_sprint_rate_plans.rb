class AddRatePlansToSprintRatePlans < ActiveRecord::Migration
  def up
    boost = SprintCarrier.find_by name: 'Boost Mobile' || return
    boost_rate_plans = ['Unknown', '$55/Monthly', '$45/Monthly', '$35/Monthly', '$3/Daily', '$2/Daily']
    boost_rate_plans.each { |rate_plan| SprintRatePlan.create name: rate_plan, carrier_id: boost.id }

    virgin = SprintCarrier.find_by name: 'Virgin Mobile' || return
    virgin_rate_plans = ['Unknown', '$55/Monthly', '$45/Monthly', '$35/Monthly', '$25/Promo']
    virgin_rate_plans.each { |rate_plan| SprintRatePlan.create name: rate_plan, carrier_id: virgin.id }

    virgin_mobile_data_share = SprintCarrier.find_by name: 'Virgin Mobile Data Share' || return
    virgin_mobile_data_share_rate_plans = ['Unknown', '$45', '$35', '$115 Shared', '$90 Shared', '$65 Shared', '$0 - Line 2', '$0 - Line 3', '$0 - Line 4']
    virgin_mobile_data_share_rate_plans.each { |rate_plan| SprintRatePlan.create name: rate_plan, carrier_id: virgin_mobile_data_share.id }

    bb2go = SprintCarrier.find_by name: 'BB2Go' || return
    bb2go_rate_plans = ['Unknown', '$120/Promo 6GB/6mo.', '$55/Monthly 6GB', '$25/Monthly 1.5GB', '$20/Promo 1GB', '$5/Daily 250MB']
    bb2go_rate_plans.each { |rate_plan| SprintRatePlan.create name: rate_plan, carrier_id: bb2go.id }

    paylo = SprintCarrier.find_by name: 'payLo' || return
    paylo_rate_plans = ['Unknown', '$40/Monthly UNL', '$30/Monthly 1500', '$20/Monthly TXT', '$20/Monthly TLK']
    paylo_rate_plans.each { |rate_plan| SprintRatePlan.create name: rate_plan, carrier_id: paylo.id }

    sprint = SprintCarrier.find_by name: 'Sprint' || return
    sprint_rate_plans = ['Easy Pay', 'Family Share', 'Simply Unlimited', 'Unlimited', 'Other']
    sprint_rate_plans.each { |rate_plan| SprintRatePlan.create name: rate_plan, carrier_id: sprint.id }
  end

  def down
    SprintRatePlan.destroy_all
  end
end
