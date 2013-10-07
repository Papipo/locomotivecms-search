require "locomotive/engine"

module Locomotive::Search  
  class Engine < ::Rails::Engine
    initializer "locomotive.search.concerns" do
      require "locomotive/search/concerns"
    end
  end
end