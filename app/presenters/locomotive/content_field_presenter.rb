require_dependency Locomotive::Engine.root.join('app', 'presenters', 'locomotive', 'content_field_presenter').to_s

Locomotive::ContentFieldPresenter.class_eval do
  properties :searchable, type: 'Boolean'
end