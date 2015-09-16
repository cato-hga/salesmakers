class AddRatePlansToSprintRatePlans < ActiveRecord::Migration
  def self.up
    boost = SprintCarrier.find_by name: 'Boost Mobile'
    return unless boost
    boost_rate_plans = ['Unknown', '$55/Monthly', '$45/Monthly', '$35/Monthly', '$3/Daily', '$2/Daily', 'UPGRADE']
    boost_rate_plans.each { |rate_plan| SprintRatePlan.create name: rate_plan, sprint_carrier_id: boost.id }

    virgin = SprintCarrier.find_by name: 'Virgin Mobile'
    return unless virgin
    virgin_rate_plans = ['Unknown', '$55/Monthly', '$45/Monthly', '$35/Monthly', '$25/Promo', 'UPGRADE']
    virgin_rate_plans.each { |rate_plan| SprintRatePlan.create name: rate_plan, sprint_carrier_id: virgin.id }

    virgin_mobile_data_share = SprintCarrier.find_by name: 'Virgin Mobile Data Share' || return
    virgin_mobile_data_share_rate_plans = ['Unknown', '$115 Shared', '$90 Shared', '$65 Shared', '$45', '$35', '$0 - Line 2',
                                           '$0 - Line 3', '$0 - Line 4', 'UPGRADE']
    virgin_mobile_data_share_rate_plans.each { |rate_plan| SprintRatePlan.create name: rate_plan, sprint_carrier_id: virgin_mobile_data_share.id }

    bb2go = SprintCarrier.find_by name: 'BB2Go'
    return unless bb2go
    bb2go_rate_plans = ['Unknown', '$120/Promo 6GB/6mo.', '$55/Monthly 6GB', '$25/Monthly 1.5GB', '$20/Promo 1GB', '$5/Daily 250MB', 'UPGRADE']
    bb2go_rate_plans.each { |rate_plan| SprintRatePlan.create name: rate_plan, sprint_carrier_id: bb2go.id }

    paylo = SprintCarrier.find_by name: 'payLo'
    return unless paylo
    paylo_rate_plans = ['Unknown', '$40/Monthly UNL', '$30/Monthly 1500', '$20/Monthly TLK', '$20/Monthly TXT',
                        'PayLo Upgrade', 'Assurance Upgrade']
    paylo_rate_plans.each { |rate_plan| SprintRatePlan.create name: rate_plan, sprint_carrier_id: paylo.id }

    sprint = SprintCarrier.find_by name: 'Sprint'
    return unless sprint
    sprint_rate_plans = ['Easy Pay', 'Family Share', 'Simply Unlimited', 'Unlimited', 'Other', 'UPGRADE']
    sprint_rate_plans.each { |rate_plan| SprintRatePlan.create name: rate_plan, sprint_carrier_id: sprint.id }
  end

  def self.down
    SprintRatePlan.destroy_all
  end
end
