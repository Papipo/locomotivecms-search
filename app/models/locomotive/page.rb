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
end