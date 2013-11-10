require_dependency Locomotive::Engine.root.join('app', 'models', 'locomotive', 'page').to_s

Locomotive::Page.class_eval do

  include Locomotive::Search::Extension

  ## fields ##
  field :searchable, type: Boolean, default: true

  ## behaviours ##
  search_by [:title, :searchable_content, store: [:title, :site_id, :fullpath]], if: :is_searchable?

  ## methods

  def indexable_id
    if respond_to?(:site_id)
      "site_#{site_id}_page_#{id}"
    else
      "page_#{id}"
    end
  end

  def is_searchable?
    !not_found? && searchable? && published?
  end

  def searchable_content
    [].tap do |content|
      # 1. add the editable elements
      self.editable_elements.each do |element|
        # we don't want to include fixed editable elements of children.
        next if !element.is_a?(Locomotive::EditableText) || (element.fixed? && element.from_parent?)
        content << element.content
      end

      # 2. add the raw template

      # get a simple version of the template. not need to apply the "layout"
      # for instance.
      # then, render this template
      template = self.raw_template.sub(/\{\%\s*extends [^%]*\s*\%\}/, '')

      # modify the context instance so that the exceptions which might raise
      # won't be displayed in the rendered output.
      context = ::Liquid::Context.new({}, {}, { site: site, page: self }, false)

      context.instance_eval do
        def handle_error(e); '' end
      end

      # render the page
      content << ::Liquid::Template.parse(template, {}).render(context)
    end.join("\n")
  end

end