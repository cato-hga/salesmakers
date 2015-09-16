class SeedVonageRepSalePayoutBrackets < ActiveRecord::Migration
  def self.up
    retail_and_event_regions = get_retail_and_event_regions
    for area in retail_and_event_regions do
      VonageRepSalePayoutBracket.create per_sale: 0.00,
                                        area: area,
                                        sales_minimum: 0,
                                        sales_maximum: 1
      VonageRepSalePayoutBracket.create per_sale: 5.00,
                                        area: area,
                                        sales_minimum: 2,
                                        sales_maximum: 2
      VonageRepSalePayoutBracket.create per_sale: 10.00,
                                        area: area,
                                        sales_minimum: 3,
                                        sales_maximum: 3
      VonageRepSalePayoutBracket.create per_sale: 12.50,
                                        area: area,
                                        sales_minimum: 4,
                                        sales_maximum: 4
      VonageRepSalePayoutBracket.create per_sale: 15.00,
                                        area: area,
                                        sales_minimum: 5,
                                        sales_maximum: 7
      VonageRepSalePayoutBracket.create per_sale: 17.50,
                                        area: area,
                                        sales_minimum: 8,
                                        sales_maximum: 9
      VonageRepSalePayoutBracket.create per_sale: 20.00,
                                        area: area,
                                        sales_minimum: 10,
                                        sales_maximum: 14
      VonageRepSalePayoutBracket.create per_sale: 25.00,
                                        area: area,
                                        sales_minimum: 15,
                                        sales_maximum: 99
    end
    project = Project.find_by(name: 'Vonage')
    area = Area.find_by(name: 'Pilot Retail Region')
    return unless area
    VonageRepSalePayoutBracket.create per_sale: 0.00,
                                      area: area,
                                      sales_minimum: 0,
                                      sales_maximum: 0
    VonageRepSalePayoutBracket.create per_sale: 10.00,
                                      area: area,
                                      sales_minimum: 1,
                                      sales_maximum: 5
    VonageRepSalePayoutBracket.create per_sale: 15.00,
                                      area: area,
                                      sales_minimum: 6,
                                      sales_maximum: 99
  end

  def self.down
    VonageRepSalePayoutBracket.destroy_all
  end

  private

  def get_retail_and_event_regions
    project = Project.find_by(name: 'Vonage')
    return [] unless project
    retail_and_event_regions = []
    retail_and_event_regions << Area.find_by(name: 'Central Retail Region', project: project)
    retail_and_event_regions << Area.find_by(name: 'North Retail Region', project: project)
    retail_and_event_regions << Area.find_by(name: 'Northwest Retail Region', project: project)
    retail_and_event_regions << Area.find_by(name: 'Southeast Retail Region', project: project)
    retail_and_event_regions << Area.find_by(name: 'Southwest Retail Region', project: project)
    project = Project.find_by(name: 'Vonage Events')
    return retail_and_event_regions unless project
    retail_and_event_regions << Area.find_by(name: 'Northeast Events Region', project: project)
    retail_and_event_regions << Area.find_by(name: 'West Events Region', project: project)
    retail_and_event_regions.compact
  end
end
