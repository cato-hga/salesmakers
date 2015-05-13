class CreateSprintPostPaidMarketAreaType < ActiveRecord::Migration
  def change
    postpaid = Project.find_by name: 'Sprint Postpaid'
    AreaType.create name: 'Sprint Postpaid Market', project: postpaid
  end
end
