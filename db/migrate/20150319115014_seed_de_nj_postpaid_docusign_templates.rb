class SeedDeNjPostpaidDocusignTemplates < ActiveRecord::Migration
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
        { state: 'DE', template_guid: '80EE400A-7308-4C2B-A137-39C65DF4721D' },
        { state: 'NJ', template_guid: 'BCF1F613-85E7-4F47-BB8C-04688906A62D' },
    ]
  end
end
