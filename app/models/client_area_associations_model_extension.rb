module ClientAreaAssociationsModelExtension

  def setup_assocations
    setup_belongs_to_associations
    setup_has_many_assocations
    setup_has_many_through_associations
  end

  def setup_belongs_to_associations
    belongs_to :client_area_type
    belongs_to :project
  end

  def setup_has_many_assocations
    #has_many :person_client_areas
    #has_many :people, through: :person_client_areas
    has_many :location_client_areas
  end

  def setup_has_many_through_associations
    # has_many :managers, -> {
    #   where('person_client_areas.manages = true')
    # }, class_name: Person, source: :person, through: :person_client_areas
    # has_many :non_managers, -> {
    #   where('person_client_areas.manages = false')
    # }, class_name: Person, source: :person, through: :person_client_areas
    # has_many :locations, through: :location_client_areas
  end

end