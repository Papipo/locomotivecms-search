Locomotive.Views.Shared ||= {}

class Locomotive.Views.Shared.SearchBarView extends Backbone.View

  el: '#search-bar'

  initialize: ->
    _.bindAll @, 'search'

  render: ->
    @enable_type_head()

    @

  enable_type_head: ->
    $input = @$('input[type=text]')

    @typeahead = $input.typeahead({
        hint:       true
        highlight:  true
        minLength:  2
      }, {
        source:     @indexer(per_page: 10)
        displayKey: 'title'
        templates:
          empty:      ich.no_search_entries_found
          suggestion: ich.search_entry
      }
    )
    .on 'typeahead:closed', (event, datum) =>
      @$('.twitter-typeahead').removeClass('on').removeClass('opened')
      # remove a UI bug if pressing the bottom key when closing the typeahead widget
      $('a')[0].focus()

    .on 'typeahead:selected', (event, suggestion, datum) =>
      event.stopPropagation() & event.preventDefault()
      window.location.href = suggestion.path

    .data('ttTypeahead').dropdown.onSync 'datasetRendered', =>
      dropdown = $input.data('ttTypeahead').dropdown

      if dropdown.isEmpty
        @$('.twitter-typeahead').removeClass('opened')
      else
        @$('.twitter-typeahead').addClass('opened')

    @$('.twitter-typeahead').on 'click', ->
      $(this).addClass('on').removeClass('opened')


  indexer: (params) ->
    (query, cb) =>
      @search query, (success, content) =>
        cb(content) if success
      , params

  search: (query, callback, params) ->
    $.ajax
      url:  @$('form').attr('action')
      data: _.extend(params || {}, { query: query })
      success: (data, statusText, xhr) =>
        callback(true, data.results)
      dataType: 'json'
