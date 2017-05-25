module TagsHelper

  def tag_tag(tag)
    return nil if tag.nil?
    pieces =  [controlled_vocabulary_term_tag(tag.keyword), tag.tag_object_type, object_tag(tag.tag_object)]
    pieces.compact.join(': ').html_safe
  end

  def tag_annotation_tag(tag)
    return nil if tag.nil?
    content_tag(:div, controlled_vocabulary_term_tag(tag.keyword), class: [:annotation__tag])
  end

  # @return [String (html), nil]
  #    a ul/li of tags for the object
  def tag_list_tag(object)
    return nil unless object.has_tags? && object.tags.any?
    content_tag(:h3, 'Tags') +
      content_tag(:ul, class: 'annotations__tag_list') do
      object.tags.collect { |a| content_tag(:li, tag_annotation_tag(a)) }.join.html_safe
    end
  end
  
  def tags_search_form
    render '/tags/quick_search_form'
  end

  def tag_link(tag)
    return nil if tag.nil?
    link_to(tag_tag(tag), metamorphosize_if(tag.tag_object))
  end

  def link_to_destroy_tag(link_text, tag)
    link_to(link_text, '', class: 'tag-destroy', tag_id: tag.id)
  end

  def add_tag_link(object: nil, attribute: nil) # tag_object is to be tagged
    link_to('Add tag',
            new_tag_path(tag_object_id: object.id, tag_object_type: object.class.name, tag_object_attribute: attribute),
            id: "tag_splat_#{object.class}_#{object.id}"
            # José - icon via class and or data-attribute here
           )
  end

  def destroy_tag_link(tag)
    destroy_object_link(tag)
  end

  # @return [True]
  #   indicates a custom partial should be used, see list_helper.rb
  def tags_recent_objects_partial
    true
  end

end
