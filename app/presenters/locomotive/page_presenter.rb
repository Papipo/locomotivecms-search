require_dependency Locomotive::Engine.root.join('app', 'presenters', 'locomotive', 'page_presenter').to_s

Locomotive::PagePresenter.class_eval do
  properties :searchable, type: 'Boolean'
end