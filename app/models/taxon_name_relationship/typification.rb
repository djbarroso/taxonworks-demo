class TaxonNameRelationship::Typification < TaxonNameRelationship

  def self.assignable
    false
  end

  def self.disjoint_classes
    self.collect_descendants_and_itself_to_s(TaxonNameClassification::Iczn::Unavailable,
          TaxonNameClassification::Icn::EffectivelyPublished::InvalidlyPublished,
          TaxonNameClassification::Icn::NotEffectivelyPublished)
  end

  def self.disjoint_subject_classes
    self.disjoint_classes
  end

  def self.disjoint_object_classes
    self.disjoint_classes
  end

  def self.nomenclatural_priority
    :reverse
  end

  def subject_status_connector_to_object
    ' of'
  end


  def object_status_connector_to_subject
    ' with'
  end

  def sv_coordinated_taxa_object
    true # not applicable
  end
end
