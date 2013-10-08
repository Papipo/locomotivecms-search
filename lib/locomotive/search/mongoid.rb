require 'locomotive/search'

class Locomotive::Search::Engine
  initializer "locomotive.search.extension", before: "locomotive.search.concerns" do
    require 'activesearch/mongoid'
    Locomotive::Search::Extension = ActiveSearch::Mongoid
  end
end