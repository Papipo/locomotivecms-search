require_dependency Locomotive::Engine.root.join('app', 'models', 'locomotive', 'page').to_s

Locomotive::Page.class_eval do
  include Locomotive::Search::Extension

  field :searchable, type: Boolean, default: false
  search_by [:title, :searchable_content, store: [:title, :site_id, :fullpath]], if: :is_searchable?

  def indexable_id
    if respond_to?(:site_id)
      "site_#{site_id}_page_#{id}"
    else
      "page_#{id}"
    end
  end
  
  def is_searchable?
    !not_found? && searchable && published
  end

  def searchable_content
    [].tap do |content|
      self.serialized_template_translations.values.each do |template|
        _content = ActiveSearch.strip_tags(raw_template)

        liquid_raw = _content.match /\{\%\s*raw\s*\%\}.*\{\%\s*endraw\s*\%\}/m

        _content.gsub!(/\n{2,}/, "\n")
        _content.gsub!(/\{[\%\{][^\}]*[\%\}]\}/, '')

        _content << liquid_raw.to_s

        content << _content
      end

      self.editable_elements.each do |element|
        next unless element.is_a?(Locomotive::EditableText)

        content << ActiveSearch.strip_tags(element.attributes['content'])
      end
    end.join('+')
  end

  protected

  def to_indexable
    # Hack for the Algolia implementation since searchable_content is not considered as Mongoid field.
    super.tap do |doc|
      doc['content'] = self.searchable_content
    end
  end

end