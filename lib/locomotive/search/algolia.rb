require 'locomotive/search'

class Locomotive::Search::Engine
  initializer "locomotive.search.extension", before: "locomotive.search.concerns" do
    require 'activesearch/algolia'
    Locomotive::Search::Extension = ActiveSearch::Algolia
  end
end
