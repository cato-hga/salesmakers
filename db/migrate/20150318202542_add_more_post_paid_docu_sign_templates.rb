class AddMorePostPaidDocuSignTemplates < ActiveRecord::Migration
  def self.up
    sp = Project.find_by name: 'Sprint Postpaid'
    for template in get_templates do
      DocusignTemplate.find_or_create_by template.merge project: sp,
                                                        document_type: :nhp
    end
  end

  def self.down
    for template in get_templates do
      t = DocusignTemplate.find_by template_guid: template[:template_guid]
      next unless t
      t.destroy
    end
  end

  private

  def get_templates
    [
        {state: 'KY', template_guid: 'B4F0D3A0-F3DC-489C-8DCB-DB9249A04F7F'},
        {state: 'IN', template_guid: 'C7C3425A-506F-45E2-99FB-808D2C8F9157'},
        {state: 'PA', template_guid: '29D91AF0-76EF-4FC6-88AD-5AE427263411'},
        {state: 'MD', template_guid: 'BB7FD38E-6B6A-4476-A541-7D29CAB755D2'},
        {state: 'VA', template_guid: '96639F1D-EE0F-4407-B524-A91555E2B323'},
        {state: 'NC', template_guid: '374C9391-9616-42D8-9F78-8B7A2DA1B51F'}
    ]
  end
end
