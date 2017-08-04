module Queries

  class GeographicAreaAutocompleteQuery <   Queries::Query

    include Arel::Nodes

    # TODO: use or_clauses
    def where_sql
      named.to_sql
    end

    def all 
      (
        GeographicArea.where(name: query_string).all +  
        GeographicArea.joins(parent_child_join).where(parent_child_where.to_sql).limit(5).all +
        GeographicArea.where(where_sql).includes(:geographic_area_type, :geographic_items).order('length(name)').limit(dynamic_limit).all
      ).flatten.compact.distinct
    end

    def table
      GeographicArea.arel_table
    end

  end
end
