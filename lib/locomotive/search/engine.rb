module Locomotive::Search
  class Engine < ::Rails::Engine
    initializer "locomotive_search.setup" do
      require "activesearch/#{Locomotive.config.search_engine}"
      require "locomotive/search/concerns"
      ::Locomotive::Search::Extension = ::ActiveSearch.const_get(Locomotive.config.search_engine.to_s.classify)
    end
  end
end
