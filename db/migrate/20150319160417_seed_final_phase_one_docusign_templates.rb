class SeedFinalPhaseOneDocusignTemplates < ActiveRecord::Migration
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
        {state: 'SC', template_guid: '271A77A0-CF24-412E-AA92-9C224352C0F5'},
        {state: 'AL', template_guid: 'B8D9634E-C731-480A-8640-36E64A0D1748'},
        {state: 'CO', template_guid: '3FB60780-BB18-4E88-93BC-54BA2FA03DC7'},
        {state: 'HI', template_guid: 'E825726B-16FC-412D-9EA6-D4EEB4E9B06E'},
        {state: 'ID', template_guid: '53220C73-07B6-4341-8594-1982756695C1'},
        {state: 'LA', template_guid: '416F0755-52E3-4674-82F4-171E0602D3C1'},
        {state: 'ME', template_guid: '9F0046B4-1BE7-4C33-AE28-91D78E73FC98'},
        {state: 'MI', template_guid: 'C38B8567-6551-479C-A2C7-69D47943A85E'},
        {state: 'MS', template_guid: 'FA71C7F3-6581-4293-998D-48BBECCE9F11'},
        {state: 'NM', template_guid: '10A801FC-E2D9-4761-BF49-2BDC5D0616A8'},
        {state: 'OH', template_guid: '3ED99DFB-8556-43CF-BAFA-88AC7BC135C1'},
        {state: 'OK', template_guid: '4282E4B6-D64D-4CFD-864A-992F614CA21C'},
        {state: 'RI', template_guid: 'D1BED618-A7C5-4F5F-A6AF-7C4AA05BA262'},
        {state: 'UT', template_guid: '7500072F-90CF-463C-810A-28E071A2A267'},
        {state: 'PR', template_guid: 'F0831DE4-20C9-4B2E-8179-C5A92C801278'},
    ]
  end
end
