class SeedNoticesOfSeparation < ActiveRecord::Migration
  def up
    comcast = Project.find_by name: 'Comcast Retail'
    directv = Project.find_by name: 'DirecTV Retail'
    sprint_prepaid = Project.find_by name: 'Sprint Retail'
    vonage_events = Project.find_by name: 'Vonage Events'
    vonage_retail = Project.find_by name: 'Vonage'
    t = DocusignTemplate.create template_guid: 'DF06A6E0-2F29-4231-AAFC-8388DA4272F0',
                                state: 'FL',
                                document_type: :nos,
                                project: comcast if comcast
    t = DocusignTemplate.create template_guid: 'E1D0E44E-40ED-4A8A-ABEF-C3F1ED01E4C7',
                                state: 'FL',
                                document_type: :nos,
                                project: directv if directv
    t = DocusignTemplate.create template_guid: '9751385F-B4DC-4CAA-A0AF-E06D9EAA5165',
                                state: 'FL',
                                document_type: :nos,
                                project: sprint_prepaid if sprint_prepaid
    t = DocusignTemplate.create template_guid: '6EBEE780-C1F5-4C9D-8505-B2E095F15CC8',
                                state: 'FL',
                                document_type: :nos,
                                project: vonage_events if vonage_events
    t = DocusignTemplate.create template_guid: '6EBEE780-C1F5-4C9D-8505-B2E095F15CC8',
                                state: 'FL',
                                document_type: :nos,
                                project: vonage_retail if vonage_retail
  end
end