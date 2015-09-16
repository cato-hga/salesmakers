class AddCarriersToSprintCarriers < ActiveRecord::Migration
  def up
    prepaid = Project.find_by name: 'Sprint Retail'
    return if prepaid.nil?
    carrier_names = ['BB2Go', 'Boost Mobile', 'payLo', 'Virgin Mobile', 'Virgin Mobile Data Share']
    carrier_names.each { |carrier_name| SprintCarrier.create name: carrier_name, project_id: prepaid.id }

    postpaid = Project.find_by name: 'Sprint Postpaid' || return
    SprintCarrier.create name: 'Sprint', project_id: postpaid.id
  end

  def down
    SprintCarrier.destroy_all
  end
end
