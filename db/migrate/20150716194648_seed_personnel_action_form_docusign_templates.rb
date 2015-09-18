class SeedPersonnelActionFormDocusignTemplates < ActiveRecord::Migration
  def up
    comcast = Project.find_by name: 'Comcast Retail'
    directv = Project.find_by name: 'DirecTV Retail'
    sprint_postpaid = Project.find_by name: 'Sprint Postpaid'
    sprint_prepaid = Project.find_by name: 'Sprint Retail'
    vonage_events = Project.find_by name: 'Vonage Events'
    vonage_retail = Project.find_by name: 'Vonage'
    for state in ::UnitedStates do
      t = DocusignTemplate.create template_guid: 'CDA4C272-7D6F-470D-85D9-E228173F4FBD',
                                  state: state,
                                  document_type: :paf,
                                  project: comcast if comcast
      t = DocusignTemplate.create template_guid: '2F87DA7F-D01A-4481-843B-0E28B6C0EC94',
                                  state: state,
                                  document_type: :paf,
                                  project: directv if directv
      t = DocusignTemplate.create template_guid: 'AB51323B-0054-4EF9-AF45-7FB0D21F67E9',
                                  state: state,
                                  document_type: :paf,
                                  project: sprint_postpaid if sprint_postpaid
      t = DocusignTemplate.create template_guid: 'AB51323B-0054-4EF9-AF45-7FB0D21F67E9',
                                  state: state,
                                  document_type: :paf,
                                  project: sprint_prepaid if sprint_prepaid
      t = DocusignTemplate.create template_guid: 'ED54C932-2A48-4C9B-9243-F14F691A1DC0',
                                  state: state,
                                  document_type: :paf,
                                  project: vonage_events if vonage_events
      t = DocusignTemplate.create template_guid: 'ED54C932-2A48-4C9B-9243-F14F691A1DC0',
                                  state: state,
                                  document_type: :paf,
                                  project: vonage_retail if vonage_retail
    end

  end
end
