module Locomotive::Search::SearchablePage

  extend ActiveSupport::Concern

  included do
    field :searchable, default: false

    alias :to_safe_params_without_search :to_safe_params
    alias :to_safe_params :to_safe_params_with_search
  end

  def to_safe_params_with_search
    to_safe_params_without_search.merge({
      searchable: self.searchable
    })
  end

end