require_dependency Locomotive::Engine.root.join('app', 'models', 'locomotive', 'content_entry').to_s

Locomotive::ContentEntry.class_eval do
  include Locomotive::Search::Extension

  search_by :options_for_search

  def options_for_search
    store = [:search_type, :label, :_slug, :site_id, :content_type_slug]
    content_type.entries_custom_fields.where(searchable: true).map(&:name) << {
      store:  store,
      locale: proc { ::Mongoid::Fields::I18n.locale }
    }
  end

  def search_type
    self.content_type.name
  end

  def label
    self._label
  end

  def content_type_slug
    self.content_type.slug
  end

  def indexable_id
    if respond_to?(:site_id)
      "site_#{site_id}_#{content_type_slug}_#{id}"
    else
      "#{content_type_slug}_#{id}"
    end
  end

  alias_method :to_indexable_without_verbosity, :to_indexable

  def to_indexable(depth = 0)
    return self._label if depth > 0

    begin
      to_indexable_without_verbosity(depth)
    rescue Exception => e
      Rails.logger.error "Unable to index #{content_type_slug}/#{self._label}[#{self._id}], error = #{e.message}"
    end
  end

end