module Locomotive::Search::SearchablePage

  extend ActiveSupport::Concern

  included do
    field :searchable, default: false
  end

  def to_safe_params
    super.merge({
      searchable: self.searchable
    })
  end

end