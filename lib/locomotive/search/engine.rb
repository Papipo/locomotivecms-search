require "locomotive/engine"

module Locomotive::Search
  def self.const_missing(const)
    if const.to_s == "Extension"
      require "activesearch/#{Locomotive.config.search_engine}"
      require "locomotive/search/concerns/activesearch/#{Locomotive.config.search_engine}/model" rescue nil
      const_set(const, ::ActiveSearch.const_get(Locomotive.config.search_engine.to_s.classify))
    end
  end
  
  class Engine < ::Rails::Engine
    initializer "locomotive.search.concerns" do
      require "locomotive/search/concerns"
    end
  end
end