module Locomotive::Search::SearchableContentField

  extend ActiveSupport::Concern

  included do
    field :searchable, default: false
  end

  def to_params
    super.merge({
      searchable: self.searchable
    })
  end

end