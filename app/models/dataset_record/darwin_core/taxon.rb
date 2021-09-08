class DatasetRecord::DarwinCore::Taxon < DatasetRecord::DarwinCore

  KNOWN_KEYS_COMBINATIONS = [
    %i{uninomial},
    %i{uninomial rank parent},
    %i{genus species},
    %i{genus species infraspecies},
    %i{genus subgenus species},
    %i{genus subgenus species infraspecies}
  ]

  PARSE_DETAILS_KEYS = %i(uninomial genus species infraspecies)

  def import(dwc_data_attributes = {})
    begin
      DatasetRecord.transaction do
        self.metadata.delete("error_data")

        nomenclature_code = get_field_value("nomenclaturalCode")&.downcase&.to_sym || import_dataset.default_nomenclatural_code
        parse_results_details = Biodiversity::Parser.parse(get_field_value("scientificName") || "")[:details]&.values&.first

        parse_results = Biodiversity::Parser.parse(get_field_value(:scientificName) || "")
        parse_results_details = parse_results[:details]
        parse_results_details = (parse_results_details&.keys - PARSE_DETAILS_KEYS).empty? ? parse_results_details.values.first : nil if parse_results_details

        raise DarwinCore::InvalidData.new({
                                            "scientificName": parse_results[:qualityWarnings] ?
                                                                parse_results[:qualityWarnings].map { |q| q[:warning] } :
                                                                ["Unable to parse scientific name. Please make sure it is correctly spelled."]
                                          }) unless (1..3).include?(parse_results[:quality]) && parse_results_details

        raise "UNKNOWN NAME DETAILS COMBINATION" unless KNOWN_KEYS_COMBINATIONS.include?(parse_results_details.keys - [:authorship])

        name_key = parse_results_details[:uninomial] ? :uninomial : (parse_results_details.keys - [:authorship]).last
        name_details = parse_results_details[name_key]

        name = name_details.kind_of?(Array) ? name_details.first[:value] : name_details

        authorship = parse_results_details.dig(:authorship, :normalized) || get_field_value("scientificNameAuthorship")

        author_name = nil

        # split authorship into name and year
        if nomenclature_code == :iczn
          if (authorship_matchdata = authorship.match(/\(?(?<author>.+?),? (?<year>\d{4})?\)?/))

            author_name = authorship_matchdata[:author]
            year = authorship_matchdata[:year]

            # author name should be wrapped in parentheses if the verbatim authorship was
            if authorship.start_with?("(") and authorship.end_with?(")")
              author_name = "(" + author_name + ")"
            end
          end

        else
          # Fall back to simple name + date parsing
          author_name = Utilities::Strings.verbatim_author(authorship)
          year = Utilities::Strings.year_of_publication(authorship)
        end

        # TODO should a year provided in namePublishedInYear overwrite the parsed value?
        year ||= get_field_value("namePublishedInYear")

        rank = get_field_value("taxonRank")
        is_hybrid = metadata["is_hybrid"] # TODO: NO...

        if metadata["parent"].nil?
          parent = project.root_taxon_name
        else
          parent = TaxonName.find(get_parent.metadata["imported_objects"]["taxon_name"]["id"])
        end

        if metadata['type'] == 'protonym'
          protonym_attributes = {
            name: name,
            parent: parent,
            rank_class: Ranks.lookup(nomenclature_code, rank),
            also_create_otu: false,
            verbatim_author: author_name,
            year_of_publication: year
          }

          taxon_name = Protonym.find_or_initialize_by(protonym_attributes.slice(:name, :parent, :rank_class, :year_of_publication))

          unless taxon_name.persisted?
            taxon_name.taxon_name_classifications.build(type: TaxonNameClassification::Icn::Hybrid) if is_hybrid
            taxon_name.data_attributes.build(import_predicate: 'DwC-A import metadata', type: 'ImportAttribute', value: {
              scientificName: get_field_value("scientificName"),
              scientificNameAuthorship: get_field_value("scientificNameAuthorship"),
              taxonRank: get_field_value("taxonRank"),
              metadata: metadata
            })

          end

          # create original combination relationship, get parent of original combination to set as subject taxon name

          original_combination_ranks = %w[genus subgenus species subspecies variety subvariety form subform]

          if get_field_value(:taxonID) == get_field_value(:originalNameUsageID)
            if original_combination_ranks.include? rank.downcase
              TaxonNameRelationship.find_or_create_by!(type: 'TaxonNameRelationship::OriginalCombination::Original' + rank.capitalize, subject_taxon_name: taxon_name, object_taxon_name: taxon_name)
            end

          else

            unless parent == project.root_taxon_name
              original_parent = TaxonName.find(find_by_taxonID(get_original_combination.metadata["parent"])
                                                 .metadata["imported_objects"]["taxon_name"]["id"])

              parent_rank = original_parent.rank

              if original_combination_ranks.include? parent_rank&.downcase
                TaxonNameRelationship.find_or_create_by!(type: 'TaxonNameRelationship::OriginalCombination::Original' + parent_rank&.capitalize, subject_taxon_name: original_parent, object_taxon_name: taxon_name)
              end
            end
          end

          # if taxonomicStatus is a synonym, create the relationship to acceptedNameUsageID
          if metadata["is_synonym"]
            valid_name = get_taxon_name_from_taxon_id(get_field_value(:acceptedNameUsageID))

            synonym_classes = {
              iczn: "TaxonNameRelationship::Iczn::Invalidating::Synonym",
              icnp: "TaxonNameRelationship::Icnp::Unaccepting::Synonym",
              icn: "TaxonNameRelationship::Icn::Unaccepting::Synonym"
            }.freeze

            TaxonNameRelationship.find_or_create_by(subject_taxon_name: taxon_name, object_taxon_name: valid_name, type: synonym_classes[nomenclature_code])

            # if taxonomicStatus is a homonym, invalid, unavailable, excluded, create the status
          elsif get_field_value(:taxonomicStatus) != 'valid' || get_field_value(:taxonomicStatus).nil?
            status_types = {
              homonym: 'TaxonNameClassification::Iczn::Available::Invalid::Homonym',
              invalid: 'TaxonNameClassification::Iczn::Available::Invalid',
              unavailable: 'TaxonNameClassification::Iczn::Unavailable',
              excluded: 'TaxonNameClassification::Iczn::Unavailable::Excluded'
            }.freeze

            if (status = get_field_value(:taxonomicStatus)&.downcase)

              type = status_types[status.to_sym]

              raise DarwinCore::InvalidData.new({ "taxonomicStatus": ["Couldn't find a status that matched #{status}"] }) if type.nil?

              TaxonNameClassification.find_or_create_by!(taxon_name: taxon_name, type: type)
            end
          end

        elsif metadata['type'] == 'combination'

          # get protonym by searching on the original combination
          current_name_record = find_by_taxonID(get_field_value(:originalNameUsageID))

          current_name = Protonym.find(current_name_record.metadata["imported_objects"]["taxon_name"]["id"])

          # if lowest_name.length == 0
          #   raise DarwinCore::InvalidData.new(
          #     { "scientificName": ["No protonym matches for #{name} #{protonym_author} #{year}"]
          #     })
          #
          # elsif lowest_name.length > 1
          #   raise DarwinCore::InvalidData.new(
          #     { "scientificName":
          #         ["Multiple protonym matches for  #{name} #{protonym_author} #{year}: #{lowest_name.map { |p| p.id }.join(' ,')}"]
          #     })
          # end

          # because Combination uses named arguments, we need to get the ranks of the parent names to create the combination
          if parent.is_a?(Combination)
            parent_elements = parent.combination_taxon_names.index_by { |protonym| protonym.rank }
          else
            parent_elements = { parent.rank => parent }
          end

          combination_attributes = {
            **parent_elements,
            rank => current_name
          }

          taxon_name = Combination.find_or_initialize_by(combination_attributes)

        else
          raise DarwinCore::InvalidData.new({ "originalNameUsageID": ["Could not determine if name is protonym or combination"] })
        end

        if taxon_name.save
          # TODO add relationships and combinations to this hash
          self.metadata[:imported_objects] = { taxon_name: { id: taxon_name.id } }
          self.status = "Imported"
        else
          self.status = "Errored"
          self.metadata[:error_data] = {
            messages: taxon_name.errors.messages
          }
        end

        save!

        if self.status == "Imported"
          # loop over dependants, see if all other dependencies are met, if so mark them as ready

          metadata['dependants'].each do |dependant_taxonID|

            dependent = import_dataset.core_records.where(id: import_dataset.core_records_fields
                                                                            .at(get_field_mapping(:taxonID))
                                                                            .where(value: dependant_taxonID)
                                                                            .select(:dataset_record_id)
            ).first

            dependency_taxon_ids = dependent.metadata["dependencies"]

            dependencies = import_dataset.core_records.where(id: import_dataset.core_records_fields
                                                                               .at(get_field_mapping(:taxonID))
                                                                               .where(value: dependency_taxon_ids.map { |d| d.to_s })
                                                                               .select(:dataset_record_id)
            )

            if dependencies.all? { |d| d[:status] == "Imported" }
              dependent.update(status: "Ready")
            end

          end

          # import_dataset.core_records.where(status: "NotReady")
          #   .where(id: import_dataset.core_records_fields
          #     .at([get_field_mapping(:parentNameUsageID), get_field_mapping(:acceptedNameUsageID)])
          #     .with_value(taxon_id)
          #     .select(:dataset_record_id)
          #   ).update_all(status: "Ready")
        end
      end
    rescue DarwinCore::InvalidData => invalid
      self.status = "Errored"
      self.metadata["error_data"] = { messages: invalid.error_data }
    rescue ActiveRecord::RecordInvalid => invalid
      self.status = "Errored"
      self.metadata["error_data"] = {
        messages: invalid.record.errors.messages
      }
    rescue StandardError => e
      raise if Rails.env.development?
      self.status = "Failed"
      self.metadata[:error_data] = {
        exception: {
          message: e.message,
          backtrace: e.backtrace
        }
      }
      save!
    end

    self
  end

  private

  def get_parent
    import_dataset.core_records.where(id: import_dataset.core_records_fields
                                                        .at(get_field_mapping(:taxonID))
                                                        .with_value(get_field_value(:parentNameUsageID))
                                                        .select(:dataset_record_id)
    ).first
  end

  def get_original_combination
    import_dataset.core_records.where(id: import_dataset.core_records_fields
                                                        .at(get_field_mapping(:taxonID))
                                                        .with_value(get_field_value(:originalNameUsageID))
                                                        .select(:dataset_record_id)
    ).first
  end

  def find_by_taxonID(taxon_id)
    import_dataset.core_records.where(id: import_dataset.core_records_fields
                                                        .at(get_field_mapping(:taxonID))
                                                        .with_value(taxon_id.to_s)
                                                        .select(:dataset_record_id)
    ).first
  end

  def get_taxon_name_from_taxon_id(taxon_id)
    TaxonName.find(find_by_taxonID(taxon_id).metadata["imported_objects"]["taxon_name"]["id"])
  end

  # TODO fix ready check for dependencies
  def data_field_changed(index, value)
    if index == get_field_mapping(:parentNameUsageID) && status == "NotReady"
      self.status = "Ready" if %w[Ready Imported].include? get_parent&.status
    end
  end

end
