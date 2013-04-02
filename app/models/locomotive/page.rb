require_dependency Locomotive::Engine.root.join('app', 'models', 'locomotive', 'page').to_s

Locomotive::Page.class_eval do
  include Locomotive::Search::Extension
  
  search_by [:title, store: [:title, :slug, :site_id]], unless: :not_found?
end