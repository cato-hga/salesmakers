class AddDocusignPostPaidNos < ActiveRecord::Migration
  def change
    postpaid = Project.find_by name: 'Sprint Postpaid'
    DocusignTemplate.create document_type: 2,
                            project: postpaid,
                            state: 'FL',
                            template_guid: 'CD15C02E-B073-44D9-A60A-6514C24949CB'
  end
end
