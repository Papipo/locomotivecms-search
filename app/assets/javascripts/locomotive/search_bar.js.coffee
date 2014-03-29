#= require_tree ./views
#= require locomotive/typeahead.js
#= require_self

# FIXME: are we doing alias_method_chain pattern here? :-)
application_view_klass = Locomotive.Views.ApplicationView.prototype
application_view_klass.render_without_search_bar = application_view_klass.render

application_view_klass.render = ->
  _.tap this.render_without_search_bar(), =>
    search_bar_view = new Locomotive.Views.Shared.SearchBarView()
    search_bar_view.render()
