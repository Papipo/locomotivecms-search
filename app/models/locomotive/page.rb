require_dependency Locomotive::Engine.root.join('app', 'models', 'locomotive', 'page').to_s

Locomotive::Page.class_eval do

  include Locomotive::Search::Extension

  ## fields ##
  field :searchable, type: Boolean, default: true

  ## behaviours ##
  search_by [
    :title, :searchable_content,
    store:  [:search_type, :label, :site_id, :fullpath],
    locale: proc { ::Mongoid::Fields::I18n.locale }
  ], if: :is_searchable?

  ## methods

  def search_type
    'page'
  end

  def label
    self.title
  end

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
      # # 1. add the editable elements
      self.editable_elements.each do |element|
        # we don't want to include fixed editable elements of children.
        next if !element.is_a?(Locomotive::EditableText) || (element.fixed? && element.from_parent?)
        content << element.content
      end

      # add the raw template by rendering it (will render the editable elements)

      # get a simple version of the template. not need to apply the "layout"
      # for instance. then, render this template
      template = self.raw_template.gsub(/\{\%\s*extends [^%]*\s*\%\}/, '')

      # modify the context instance so that the exceptions which might raise
      # won't be displayed in the rendered output.
      context = ::Liquid::Context.new({}, {}, { site: site, page: self }, false)

      context.instance_eval do
        def handle_error(e); '' end
      end

      # render the page
      begin
        document = ::Liquid::Template.parse(template, {})

        # remove all the editable_(file|text|control) elements
        remove_editable_elements_from_searchable_template(document.root)

        content << document.render(context)
      rescue Exception => e
        Rails.logger.error "Unable to index #{self.fullpath}[#{self._id}], error = #{e.message}"
      end
    end.join("\n")
  end

  def remove_editable_elements_from_searchable_template(node)
    if node.respond_to?(:nodelist)
      (node.nodelist || []).each do |child|
        if child.is_a?(Locomotive::Liquid::Tags::Editable::Base)
          node.nodelist.delete(child)
        else
          self.remove_editable_elements_from_searchable_template(child)
        end
      end
    end
  end

end