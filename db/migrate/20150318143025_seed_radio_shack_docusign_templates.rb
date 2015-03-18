class SeedRadioShackDocusignTemplates < ActiveRecord::Migration
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
        { state: 'AK', template_guid: '603E81AB-4DC0-4FBC-9028-46D1FCABDD21' },
        { state: 'FL', template_guid: '603E81AB-4DC0-4FBC-9028-46D1FCABDD21' },
        { state: 'NV', template_guid: '603E81AB-4DC0-4FBC-9028-46D1FCABDD21' },
        { state: 'SD', template_guid: '603E81AB-4DC0-4FBC-9028-46D1FCABDD21' },
        { state: 'TX', template_guid: '603E81AB-4DC0-4FBC-9028-46D1FCABDD21' },
        { state: 'WA', template_guid: '603E81AB-4DC0-4FBC-9028-46D1FCABDD21' },
        { state: 'WY', template_guid: '603E81AB-4DC0-4FBC-9028-46D1FCABDD21' },
        { state: 'NH', template_guid: '603E81AB-4DC0-4FBC-9028-46D1FCABDD21' },
        { state: 'TN', template_guid: '603E81AB-4DC0-4FBC-9028-46D1FCABDD21' },
        { state: 'AZ', template_guid: '9929D1EE-EF65-4D07-B79C-485AEC8137FB' },
        { state: 'AR', template_guid: '2BA3508D-7223-4E9B-A83D-41977BE6271B' },
        { state: 'CT', template_guid: '8A1E7F6A-E356-42D0-BBB1-7FBCD976E418' },
        { state: 'DC', template_guid: '36DADDE8-6E29-45B8-BE5B-4D100BA7B564' },
        { state: 'CA', template_guid: '2FDB226A-B7B9-44FB-AE51-F293C8FD6EBE' },
        { state: 'GA', template_guid: 'F02AD967-9D3C-49E5-AB4D-5EDF8E6A0EDD' },
        { state: 'IL', template_guid: '2313D21E-DD28-48D4-8435-2DB8A45B9435' },
        { state: 'IN', template_guid: 'C7C3425A-506F-45E2-99FB-808D2C8F9157' },
        { state: 'MA', template_guid: 'FEECE66D-8181-4C6A-8241-E73FE3260B95' },
        { state: 'NY', template_guid: '14D185B5-E913-4F50-94E9-954CC94054D6' },
        { state: 'OR', template_guid: '076AF449-0C5E-4621-B377-4EE343060F28' },
    ]
  end
end
