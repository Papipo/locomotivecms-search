require_dependency Locomotive::Engine.root.join('app', 'models', 'locomotive', 'page').to_s

Locomotive::Page.class_eval do
  include Locomotive::Search::Extension

  search_by [:title, store: [:title, :slug, :site_id]], unless: :not_found?

  def indexable_id
    if respond_to?(:site_id)
      "site_#{site_id}_page_#{id}"
    else
      "page_#{id}"
    end
  end

  def searchable_content
    [].tap do |content|
      content << ActiveSearch.strip_tags(self.raw_template_translations)

      self.editable_elements.each do |element|
        next unless element.is_a?(Locomotive::EditableText)

        content << ActiveSearch.strip_tags(element.attributes['content'])
      end
    end.join('+')
  end

  protected

  def to_indexable
    super.tap do |doc|
      doc['content']  = self.searchable_content
    end
  end

end