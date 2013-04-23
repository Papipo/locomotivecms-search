require_dependency Locomotive::Engine.root.join('app', 'models', 'locomotive', 'content_entry').to_s

Locomotive::ContentEntry.class_eval do
  include Locomotive::Search::Extension
  
  search_by :options_for_search
  
  def options_for_search
    store = [:_slug, _label_field_name, :site_id, :content_type_slug]
    content_type.entries_custom_fields.where(searchable: true).map(&:name) << {store: store}
  end
  
  def content_type_slug
    content_type.slug
  end
  
  def indexable_id
    if respond_to?(:site_id)
      "site_#{site_id}_#{content_type_slug}_#{id}"
    else
      "#{content_type_slug}_#{id}"
    end
  end
end