class TaxonNameRelationship::Icn::Unaccepting::Rejected < TaxonNameRelationship::Icn::Unaccepting

  def self.disjoint_taxon_name_relationships
    self.parent.disjoint_taxon_name_relationships +
        TaxonNameRelationship::Icn::Unaccepting::Usage.descendants.collect{|t| t.to_s}
  end

  def self.disjoint_subject_classes
    self.parent.disjoint_subject_classes +
        [TaxonNameClass::Icn::NotEffectivelyPublished.to_s] +
        TaxonNameClass::Icn::EffectivelyPublished::InvalidlyPublished.descendants.collect{|t| t.to_s} +
        TaxonNameClass::Iczn::EffectivelyPublished::ValidlyPublished::Legitimate.descendants.collect{|t| t.to_s}
  end

  def self.assignment_method
    # aus.icn_rejected = bus
    :icn_rejected
  end

  # as.
  def self.inverse_assignment_method
    # bus.set_as_icn_rejected_of(aus)
    :set_as_icn_rejected_of
  end

end