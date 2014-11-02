module Locomotive::Search::SearchableContentField

  extend ActiveSupport::Concern

  included do
    field :searchable, default: false

    alias :to_params_without_search :to_params
    alias :to_params :to_params_with_search
  end


  def to_params_with_search
    to_params_without_search.tap { |h| puts h.inspect }.merge({
      searchable: self.searchable
    })
  end

end