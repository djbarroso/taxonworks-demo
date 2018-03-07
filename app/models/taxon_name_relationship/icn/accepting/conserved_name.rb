class TaxonNameRelationship::Icn::Accepting::ConservedName < TaxonNameRelationship::Icn::Accepting

  NOMEN_URI='http://purl.obolibrary.org/obo/NOMEN_0000389'.freeze

  def self.assignable
    true
  end

  def object_status
    'rejected'
  end

  def subject_status
    'conserved'
  end

  def self.gbif_status_of_subject
    'conservandum'
  end

  def self.gbif_status_of_object
    'rejiciendum'
  end

  def self.nomenclatural_priority
    :reverse
  end

  def self.assignment_method
    # bus.set_as_icn_conserved_name_of(aus)
    :icn_set_as_conserved_name_of
  end

  def self.inverse_assignment_method
    # aus.icn_conserved_name = bus
    :icn_conserved_name
  end

end
