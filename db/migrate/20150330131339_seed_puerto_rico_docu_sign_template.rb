class SeedPuertoRicoDocuSignTemplate < ActiveRecord::Migration
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
        {state: 'PR', template_guid: 'F0831DE4-20C9-4B2E-8179-C5A92C801278'}
    ]
  end
end
