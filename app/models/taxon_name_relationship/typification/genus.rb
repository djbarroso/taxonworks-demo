class TaxonNameRelationship::Typification::Genus < TaxonNameRelationship::Typification

  # write validation to be used onyl when a genus group name
  # write validation so that the subject must be a species group name

  # left side
  def self.valid_subject_ranks
    NomenclaturalRank::ICZN::SpeciesGroup.descendants + NomenclaturalRank::ICN::SpeciesGroup 
  end

  # right_side
  def self.valid_object_ranks
  end

  def self.assignment_method
    # used like:
    #
    #   right_side instance   =  left_side instance
    #   genus.type_species = species
    #   genus.type_species_relationship # => returns a TaxonNameRelationship
    :type_species
  end

  def self.inverse_assignment_method
    # used like
    #    left_side_instance        right_side_instance
    #    species.type_of_genus(genus)
    :type_of_genus
  end

end
