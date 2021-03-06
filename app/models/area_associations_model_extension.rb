module AreaAssociationsModelExtension

  def setup_assocations
    setup_belongs_to_associations
    setup_has_many_assocations
    setup_has_many_through_associations
  end

  def setup_belongs_to_associations
    belongs_to :area_type
    belongs_to :project
    belongs_to :area_candidate_sourcing_group
  end

  def setup_has_many_assocations
    has_many :person_areas
    has_many :people, through: :person_areas
    has_many :day_sales_counts, as: :saleable
    has_many :sales_performance_ranks, as: :rankable
    has_many :location_areas
    has_many :group_me_groups
    has_many :vonage_rep_sale_payout_brackets
  end

  def setup_has_many_through_associations
    has_many :managers, -> {
      where('person_areas.manages = true')
    }, class_name: Person, source: :person, through: :person_areas
    has_many :non_managers, -> {
      where('person_areas.manages = false')
    }, class_name: Person, source: :person, through: :person_areas
    has_many :locations, through: :location_areas
  end

end