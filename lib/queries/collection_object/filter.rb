module Queries
  module CollectionObject

    # TODO 
    # - use date processing? / DateConcern
    # - syncronize with GIS/GEO

    class Filter < Queries::Query

      include Queries::Helpers

      include Queries::Concerns::Tags
      include Queries::Concerns::Users
      include Queries::Concerns::Identifiers

      # TODO: look for name collisions with CE filter

      # @param [String, nil]
      #    one of 'Specimen', 'Lot', or 'RangedLot'
      attr_accessor :collection_object_type

      # @param [String, nil]
      #  'true' - order by updated_at
      #  'false', nil - do not apply ordering
      # @return [Boolen, nil]
      attr_accessor :recent 

      # [Array]
      #   only return objects with this collecting event ID
      attr_accessor :collecting_event_ids

      # All params managed by CollectingEvent filter are available here as well
      attr_accessor :collecting_event_query

      # @return [Array, nil]
      #    a list of Otu ids, matches one ot one only
      attr_accessor :otu_ids

      # @return [Protonym.id, nil]
      #   return all collection objects determined as an Otu that is self or descendant linked
      #   to this TaxonName
      attr_accessor :ancestor_id

      # @return [Boolean, nil]
      #   nil =  Match against all ancestors, valid or invalid  
      #   true = Match against only valid ancestors
      #   false = Match against only invalid ancestors 
      attr_accessor :validity

      # @return [Boolean, nil]
      #   nil = TaxonDeterminations match regardless of current or historical
      #   true = TaxonDetermination must be .current
      #   false = TaxonDetermination must be .historical
      attr_accessor :current_determinations 

      # @return [True, nil]
      attr_accessor :on_loan

      # @return [True, nil]
      attr_accessor :loaned

      # @return [True, nil]
      attr_accessor :never_loaned

      # @return [Array]
      #   of biocuration_class ids
      attr_accessor :biocuration_class_ids

      # @return [Array]
      #   of biological_relationship_ids
      attr_accessor :biological_relationship_ids

      # @return [True, False, nil]
      #   true - index is built
      #   false - index is not built
      #   nil - not applied
      attr_accessor :dwc_indexed

      # @return [Protonym#id, nil]
      attr_accessor :type_specimen_taxon_name_id

      # @return [Repository#id, nil]
      attr_accessor :repository_id

      # @return [Array, nil]
      #  one of `holotype`, `lectotype` etc.
      #   nil - not applied
      attr_accessor :is_type

      # @return [SledImage#id, nil]
      attr_accessor :sled_image_id

      # @return [True, False, nil]
      #   true - index is built
      #   false - index is not built
      #   nil - not applied
      attr_accessor :depictions

      # @return [True, False, nil]
      #   true - has one ore more taxon_determinations
      #   false - does not have any taxon_determinations
      #   nil - not applied
      attr_accessor :taxon_determinations

      # @return [True, False, nil]
      #   true - has one ore more georeferences
      #   false - does not have any georeferences
      #   nil - not applied
      attr_accessor :georeferences

      # @return [True, False, nil]
      #   true - has repository_id 
      #   false - does not have repository_id 
      #   nil - not applied
      attr_accessor :repository

      # @return [True, False, nil]
      # @param collecting_event ['true', 'false']
      #   true - has collecting_event_id
      #   false - does not have collecting_event_id
      #   nil - not applied
      attr_accessor :collecting_event

      # @return [True, False, nil]
      #   true - has collecting event that has  geographic_area
      #   false - does not have  collecting event that has geographic area
      #   nil - not applied
      attr_accessor :geographic_area


      #---

      # @return [Array]
      # @param determiner [Array or Person#id]
      #   one ore more people id
      attr_accessor :determiner_id

      # @return [String, nil]
      attr_accessor :buffered_determinations

      # @return [Boolean, nil]
      attr_accessor :exact_buffered_determinations



      # @return [Boolean, nil]
      attr_accessor :exact_buffered_collecting_event

      # @return [String, nil]
      attr_accessor :buffered_collecting_event


      # @return [Boolean, nil]
      attr_accessor :exact_buffered_other_labels

      # @return [String, nil]
      attr_accessor :buffered_other_labels


      # @return [True, False, nil]
      #   true - has collecting event that has  geographic_area
      #   false - does not have  collecting event that has geographic area
      #   nil - not applied
      attr_accessor :type_material


      # @param [Hash] args are permitted params
      def initialize(params)
        params.reject!{ |_k, v| v.blank? } # dump all entries with empty values

        # Only CollectingEvent fields are permitted now.
        # (Perhaps) TODO: allow concern attributes nested inside as well, e.g. show me all COs with this Tag on CE.
        @collecting_event_query = Queries::CollectingEvent::Filter.new(
          params.select{|a,b| Queries::CollectingEvent::Filter::ATTRIBUTES.include?(a.to_s) }
        )

        @ancestor_id = params[:ancestor_id].blank? ? nil : params[:ancestor_id]
        @biocuration_class_ids = params[:biocuration_class_ids] || []
        @biological_relationship_ids = params[:biological_relationship_ids] || []
       
        @collecting_event = boolean_param(params, :collecting_event)

        @collecting_event_ids = params[:collecting_event_ids] || []
        @collection_object_type = params[:collection_object_type].blank? ? nil : params[:collection_object_type]
        @current_determinations = boolean_param(params, :current_determinations)
        @depictions = boolean_param(params, :depictions)
        @determiner_id = params[:determiner_id] 
        @dwc_indexed = boolean_param(params, :dwc_indexed) 
        @exact_buffered_determinations = boolean_param(params, :exact_buffered_determinations)
        @geographic_area = boolean_param(params, :geographic_area)
        @georeferences = boolean_param(params, :georeferences)
        @is_type = params[:is_type] || []
        @loaned = boolean_param(params, :loaned)
        @never_loaned = boolean_param(params, :never_loaned) 
        @on_loan =  boolean_param(params, :on_loan)
        @otu_descendants = boolean_param(params, :otu_descendants)
        @otu_ids = params[:otu_ids] || []
        @recent = params[:recent].blank? ? false : true
        @repository = boolean_param(params, :repository)
        @repository_id = params[:repository_id].blank? ? nil : params[:repository_id]
        @sled_image_id = params[:sled_image_id].blank? ? nil : params[:sled_image_id]
        @taxon_determinations = boolean_param(params, :taxon_determinations)
        @type_material = boolean_param(params, :type_material)
        @type_specimen_taxon_name_id = params[:type_specimen_taxon_name_id].blank? ? nil : params[:type_specimen_taxon_name_id]
        @validity = boolean_param(params, :validity)

        @buffered_determinations = params[:buffered_determinations]
        @buffered_collecting_event = params[:buffered_collecting_event]
        @buffered_other_labels = params[:buffered_other_labels]

        @exact_buffered_determinations = boolean_param(params, :exact_buffered_determinations)
        @exact_buffered_collecting_event = boolean_param(params, :exact_buffered_collecting_event)
        @exact_buffered_other_labels = boolean_param(params, :exact_buffered_other_labels)

        set_identifier(params)
        set_tags_params(params)
        set_user_dates(params)
      end

      # @return [Arel::Table]
      def table
        ::CollectionObject.arel_table
      end

      def base_query
        ::CollectionObject.select('collection_objects.*')
      end

      # @return [Arel::Table]
      def collecting_event_table 
        ::CollectingEvent.arel_table
      end

      # @return [Arel::Table]
      def otu_table 
        ::Otu.arel_table
      end

      # @return [Arel::Table]
      def type_materials_table 
        ::TypeMaterial.arel_table
      end

      # @return [Arel::Table]
      def depiction_table 
        ::Depiction.arel_table
      end

      # @return [Arel::Table]
      def taxon_determination_table 
        ::TaxonDetermination.arel_table
      end

      def determiner_id
        [@determiner_id].flatten.compact
      end

      def taxon_determinations_facet
        return nil if taxon_determinations.nil?

        if taxon_determinations
          ::CollectionObject.joins(:taxon_determinations).distinct
        else
          ::CollectionObject.left_outer_joins(:taxon_determinations)
            .where(taxon_determinations: {id: nil})
            .distinct
        end
      end

      def determiner_facet
        return nil if determiner_id.empty? 
        ::CollectionObject.joins(:determiners).where(roles: {person_id: determiner_id})
      end

      def georeferences_facet
        return nil if georeferences.nil?
        if georeferences
          ::CollectionObject.joins(:georeferences).distinct
        else
          ::CollectionObject.left_outer_joins(:georeferences)
            .where(georeferences: {id: nil})
            .distinct
        end
      end

      def repository_facet
        return nil if repository.nil?
        if repository
          ::CollectionObject.where.not(repository_id: nil)
        else
          ::CollectionObject.where(repository_id: nil)
        end
      end

      def collecting_event_facet
        return nil if collecting_event.nil?
        if collecting_event
          ::CollectionObject.where.not(collecting_event_id: nil)
        else
          ::CollectionObject.where(collecting_event_id: nil)
        end
      end

      def geographic_area_facet
        return nil if geographic_area.nil?

        if geographic_area 
          ::CollectionObject.joins(:collecting_event).where.not(collecting_events: {geographic_area_id: nil}).distinct
        else
          ::CollectionObject.left_outer_joins(:collecting_event)
            .where(collecting_events: {geographic_area_id: nil})
            .distinct
        end
      end

      def biocuration_facet
        return nil if biocuration_class_ids.empty?
        ::CollectionObject::BiologicalCollectionObject.joins(:biocuration_classifications).where(biocuration_classifications: {biocuration_class_id: biocuration_class_ids}) 
      end

      def type_facet 
        return nil if collection_object_type.nil?
        table[:type].eq(collection_object_type)
      end

      def depictions_facet 
        return nil if depictions.nil?

        if depictions
          ::CollectionObject.joins(:depictions).distinct
        else
          ::CollectionObject.left_outer_joins(:depictions)
            .where(depictions: {id: nil})
            .distinct
        end
      end

      def sled_image_facet 
        return nil if sled_image_id.nil?
        ::CollectionObject::BiologicalCollectionObject.joins(:depictions).where("depictions.sled_image_id = ?", sled_image_id)
      end

      def biological_relationship_ids_facet
        return nil if biological_relationship_ids.empty?
        ::CollectionObject.with_biological_relationship_ids(biological_relationship_ids)
      end

      def loaned_facet
        return nil unless loaned 
        ::CollectionObject.loaned
      end

      def never_loaned_facet
        return nil unless never_loaned 
        ::CollectionObject.never_loaned
      end

      def on_loan_facet
        return nil unless on_loan
        ::CollectionObject.on_loan
      end

      def dwc_indexed_facet 
        return nil if dwc_indexed.nil?
        dwc_indexed ?
          ::CollectionObject.dwc_indexed :
          ::CollectionObject.dwc_not_indexed
      end

      # @return Scope
      def collecting_event_ids_facet
        return nil if collecting_event_ids.empty?
        table[:collecting_event_id].eq_any(collecting_event_ids)
      end

      def repository_id_facet
        return nil if repository_id.blank?
        table[:repository_id].eq(repository_id)
      end

      def collecting_event_merge_clauses
        c = []

        # Convert base and clauses to merge clauses
        collecting_event_query.base_merge_clauses.each do |i|
          c.push ::CollectionObject.joins(:collecting_event).merge( i ) 
        end
        c
      end

      def collecting_event_and_clauses
        c = []

        # Convert base and clauses to merge clauses
        collecting_event_query.base_and_clauses.each do |i|
          c.push ::CollectionObject.joins(:collecting_event).where( i ) 
        end
        c
      end

      # @return [ActiveRecord::Relation]
      def and_clauses
        clauses = base_and_clauses

        return nil if clauses.empty?

        a = clauses.shift
        clauses.each do |b|
          a = a.and(b)
        end
        a
      end

      # @return [Array]
      def base_and_clauses
        clauses = []

        clauses += [
          attribute_exact_facet(:buffered_determinations),
          attribute_exact_facet(:buffered_collecting_event),
          attribute_exact_facet(:buffered_other_labels),
          collecting_event_ids_facet,
          type_facet,
          repository_id_facet
        ]
        clauses.compact!
        clauses
      end

      def base_merge_clauses
        clauses = []
        clauses += collecting_event_merge_clauses + collecting_event_and_clauses

        clauses += [
          determiner_facet, 
          geographic_area_facet,
          collecting_event_facet,
          repository_facet,
          type_material_facet,
          georeferences_facet,
          taxon_determinations_facet,
          otus_facet,
          type_by_taxon_name_facet,
          type_material_type_facet,
          ancestors_facet,
          keyword_id_facet,       # See Queries::Concerns::Tags
          created_updated_facet,  # See Queries::Concerns::Users
          identifiers_facet,      # See Queries::Concerns::Identifiers
          identifier_between_facet,
          identifier_facet,
          identifier_namespace_facet,
          loaned_facet,
          on_loan_facet,
          dwc_indexed_facet,
          never_loaned_facet,
          biocuration_facet,
          biological_relationship_ids_facet,
          sled_image_facet,
          depictions_facet,
        ]

        clauses.compact!
        clauses
      end

      # @return [ActiveRecord::Relation]
      def merge_clauses
        clauses = base_merge_clauses        
        return nil if clauses.empty?
        a = clauses.shift
        clauses.each do |b|
          a = a.merge(b)
        end
        a
      end

      # @return [ActiveRecord::Relation]
      def all
        a = and_clauses
        b = merge_clauses
        # q = nil
        if a && b
          q = b.where(a).distinct
        elsif a
          q = ::CollectionObject.where(a).distinct
        elsif b
          q = b.distinct
        else
          q = ::CollectionObject.all
        end

        q = q.order(updated_at: :desc) if recent
        q
      end

      # @return [Scope]
      def type_by_taxon_name_facet
        return nil if type_specimen_taxon_name_id.nil?

        w = type_materials_table[:collection_object_id].eq(table[:id])
          .and( type_materials_table[:protonym_id].eq(type_specimen_taxon_name_id) )

        ::CollectionObject.where(
          ::TypeMaterial.where(w).arel.exists
        )
      end

      # @return [Scope]
      def type_material_type_facet
        return nil if is_type.empty?

        w = type_materials_table[:collection_object_id].eq(table[:id])
          .and( type_materials_table[:type_type].eq_any(is_type) )

        ::CollectionObject.where(
          ::TypeMaterial.where(w).arel.exists
        )
      end

      def type_material_facet
        return nil if type_material.nil?
        if type_material 
          ::CollectionObject.joins(:type_designations).distinct
        else
          ::CollectionObject.left_outer_joins(:type_designations)
            .where(type_material: {id: nil})
            .distinct
        end
      end

      # @return [Scope]
      def otus_facet
        return nil if otu_ids.empty?

        w = taxon_determination_table[:biological_collection_object_id].eq(table[:id])
          .and( taxon_determination_table[:otu_id].eq_any(otu_ids) )

        if current_determinations 
          w = w.and(taxon_determination_table[:position].eq(1))
        elsif current_determinations == false
          w = w.and(taxon_determination_table[:position].gt(1))
        end

        ::CollectionObject.where(
          ::TaxonDetermination.where(w).arel.exists
        )
      end

      def ancestors_facet
        return nil if ancestor_id.nil?
        h = Arel::Table.new(:taxon_name_hierarchies)
        t = ::TaxonName.arel_table

        q = table.join(taxon_determination_table, Arel::Nodes::InnerJoin).on(
          table[:id].eq(taxon_determination_table[:biological_collection_object_id])
        ).join(otu_table, Arel::Nodes::InnerJoin).on(
          taxon_determination_table[:otu_id].eq(otu_table[:id])
        ).join(t, Arel::Nodes::InnerJoin).on(
          otu_table[:taxon_name_id].eq(t[:id])
        ).join(h, Arel::Nodes::InnerJoin).on(
          t[:id].eq(h[:descendant_id])
        )

        z = h[:ancestor_id].eq(ancestor_id)

        if validity == true
          z = z.and(t[:cached_valid_taxon_name_id].eq(t[:id]))
        elsif validity == false
          z = z.and(t[:cached_valid_taxon_name_id].not_eq(t[:id]))
        end

        if current_determinations == true
          z = z.and(taxon_determination_table[:position].eq(1))
        elsif current_determinations == false
          z = z.and(taxon_determination_table[:position].gt(1))
        end

        ::CollectionObject.joins(q.join_sources).where(z)
      end

      # @return [Scope]
      def geographic_area_scope
        # This could be simplified if the AJAX selector returned a geographic_item_id rather than a GeographicAreaId
        target_geographic_item_ids = []
        geographic_area_ids.each do |ga_id|
          target_geographic_item_ids.push(::GeographicArea.joins(:geographic_items)
            .find(ga_id)
            .default_geographic_item.id)
        end
        ::CollectionObject.joins(:geographic_items)
          .where(::GeographicItem.contained_by_where_sql(target_geographic_item_ids))
      end


    end

  end
end
