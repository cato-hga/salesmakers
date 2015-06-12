require 'sale_importer'

class DaySalesCount < ActiveRecord::Base

  def self.validations_and_assocations
    validates :day, presence: true
    validates :saleable, presence: true
    validates :sales, presence: true

    belongs_to :saleable, polymorphic: true
  end

  def self.range_scopes
    range_scope
    period_scope
  end

  def self.range_scope
    scope :for_range, ->(range) {
      where('day >= ? AND day <= ?',
            range.first,
            range.last)
    }
  end

  def self.period_scope
    scope :for_period, ->(period, last = false) {
      for_range (Date.today.send("beginning_of_#{period}".to_sym) - (last ? 1.send(period.to_sym) : 0))..
                    (last ? Date.today.send("beginning_of_#{period}".to_sym) - 1.day : Date.today)
    }
  end

  def self.day_scopes
    scope :today, -> { where day: Date.today }
    scope :yesterday, -> { where day: Date.yesterday }
  end

  def self.week_scopes
    scope :this_week, -> { for_period 'week' }
    scope :last_week, -> { for_period 'week', true }
  end

  def self.month_scopes
    scope :this_month, -> { for_period 'month' }
    scope :last_month, -> { for_period 'month', true }
  end

  def self.year_scopes
    scope :this_year, -> { for_period 'year' }
  end

  def self.reps_scope
    scope :for_reps, ->(person, project = nil) {
      none unless person
      reps = Person.visible(person)
      if project
        areas = Area.where project: project
        person_areas = PersonArea.where area: areas, person: reps
        people = person_areas.map {|pa| pa.person}
      end
      where(saleable: people)
    }
  end

  def self.location_areas_scope
    scope :for_location_areas, ->(person, project = nil) {
      none unless person
      areas = Area.visible(person, true)
      none if areas.empty?
      areas = areas.where(project: project) if project
      location_areas = []
      for area in areas do
        location_areas.concat area.location_areas
      end
      where(saleable: location_areas.flatten.uniq)
    }
  end

  def self.areas_scope
    scope :for_areas, ->(person, project = nil) {
      none unless person
      areas = Area.visible person, true
      none if areas.empty?
      areas = areas.where(project: project) if project
      where(saleable: areas)
    }
  end

  def self.projects_scope
    scope :for_projects, -> {
      all
    }
  end

  def self.clients_scope
    scope :for_clients, -> {
      all
    }
  end

  def self.depth_scopes
    reps_scope
    location_areas_scope
    areas_scope
    projects_scope
    clients_scope

    scope :for_depth, ->(person, depth = 6, project = nil) {
      none unless person
      case depth
        when 6
          for_reps person, project
        when 5
          for_location_areas person, project
        when 4
          for_areas person, project
        when 3
          for_areas person, project
        when 2
          for_areas person, project
        when 1
          for_projects person
        else
          none
      end
    }
  end

  validations_and_assocations
  range_scopes
  day_scopes
  week_scopes
  month_scopes
  year_scopes
  depth_scopes

  def self.import automated = false
    SaleImporter.new automated
  end

end
