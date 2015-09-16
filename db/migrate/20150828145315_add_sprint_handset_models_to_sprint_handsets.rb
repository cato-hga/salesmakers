class AddSprintHandsetModelsToSprintHandsets < ActiveRecord::Migration
  def up
    boost = SprintCarrier.find_by name: 'Boost Mobile'
    return unless boost
    boost_models = ['Alcatel Onetouch Fling', 'Boost Warp 4G', 'HTC Desire 510', 'Kyocera Hydro', 'Kyocera Hydro Edge',
                    'Kyocera Icon', 'Kyocera Verve', 'LG Realm', 'LG Volt', 'Moto G', 'Nokia Lumia 635', 'Samsung Galaxy Prevail 2',
                    'Samsung Galaxy Rush', 'Sharp Aquos', 'ZTE Speed', 'ZTE Warp Sequent', 'Other Device'
    ]
    boost_models.each { |model_name| SprintHandset.create name: model_name, carrier_id: boost.id }

    virgin = SprintCarrier.find_by name: 'Virgin Mobile'
    return unless virgin
    virgin_models = ['Custom', 'Kyocera Event', 'Kyocera Rise', 'Kyocera Vibe', 'LG Optimus F3', 'LG Volt', 'Samsung Galaxy Ring',
                     'ZTE Awe', 'ZTE Reef', 'Other Device'
    ]
    virgin_models.each { |model_name| SprintHandset.create name: model_name, carrier_id: virgin.id }

    virgin_mobile_date_share = SprintCarrier.find_by name: 'Virgin Mobile Data Share' || return
    virgin_date_share_models = ['Galaxy Core Prime', 'HTC Desire 510', 'LG Tribute' 'LG Volt', 'Other Device']
    virgin_date_share_models.each { |model_name| SprintHandset.create name: model_name, carrier_id: virgin_mobile_date_share.id }

    bb2go = SprintCarrier.find_by name: 'BB2Go'
    return unless bb2go
    bb2go_models = ['Mingle', 'Other Device']
    bb2go_models.each { |model_name| SprintHandset.create name: model_name, carrier_id: bb2go.id }

    paylo = SprintCarrier.find_by name: 'payLo'
    return unless paylo
    paylo_models = ['Kyocera Contact', 'Kyocera Kona', 'LG Aspire', 'Samsung Montage', 'Other Device']
    paylo_models.each { |model_name| SprintHandset.create name: model_name, carrier_id: paylo.id }

    sprint = SprintCarrier.find_by name: 'Sprint'
    return unless sprint
    sprint_models = ['Apple iPhone 6 Plus', 'Apple iPhone 6', 'Apple iPhone 5S', 'Apple iPhone 5C', 'LG G3', 'Motorola Moto X',
                     'Samsung Galaxy Mega', 'Samsung Galaxy Note 4', 'Samsung Galaxy Note 3', 'Samsung Galaxy S5', 'Samsung Galaxy S4',
                     'Other Device']
    sprint_models.each { |model_name| SprintHandset.create name: model_name, carrier_id: sprint.id }
  end

  def down
    SprintHandset.destroy_all
  end
end
