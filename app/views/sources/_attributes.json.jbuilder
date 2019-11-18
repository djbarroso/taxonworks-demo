json.extract! source, :id, :serial_id, :address, :annote, :author,
  :booktitle, :chapter, :crossref, :edition, :editor,
  :howpublished, :institution, :journal, :key, :month, :note,
  :number, :organization, :pages, :publisher, :school, :series,
  :title, :type, :volume, :doi, :abstract, :copyright, :language,
  :stated_year, :verbatim, :cached, :cached_author_string,
  :bibtex_type, :created_by_id, :updated_by_id, :cached_nomenclature_date,
  :day, :year, :isbn, :issn, :verbatim_contents, :verbatim_keywords,
  :language_id, :translator, :year_suffix, :url, :created_at, :updated_at

json.partial! '/shared/data/all/metadata', object: source, klass: 'Source'

json.source_in_project source_in_project?(source)
json.project_source_id project_source_for_source(source)&.id

if source.type == 'Source::Bibtex'

  json.authors(@source.authors) do |p|
    json.id p.id
    json.partial! '/shared/data/all/metadata', object: p
  end

  json.editors(@source.editors) do |p|
    json.id p.id
    json.partial! '/shared/data/all/metadata', object: p
  end

end

json.documents do |d|
  d.array! source.documents, partial: '/documents/attributes', as: :document
end
