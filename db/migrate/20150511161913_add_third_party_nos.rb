class AddThirdPartyNos < ActiveRecord::Migration
  def change
    postpaid = Project.find_by name: 'Sprint Postpaid'
    DocusignTemplate.create document_type: 2,
                            project: postpaid,
                            state: 'FL',
                            template_guid: 'E0D92C92-D229-4C25-9CAF-E258FA990AF5'
  end
end
