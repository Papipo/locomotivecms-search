module Locomotive::Search::SearchableContentEntry

  extend ActiveSupport::Concern

  def searchable?
    self.content_type.fields.any? { |field| field.searchable == true }
  end

end