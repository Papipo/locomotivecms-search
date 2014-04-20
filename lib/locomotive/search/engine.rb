module Locomotive::Search
  class Engine < ::Rails::Engine

    initializer "locomotive.search.concerns", before: "locomotive.content_types" do |app|
      require "locomotive/search/content_type_reindexer"
      require "locomotive/search/concerns"

      app.config.autoload_paths += %W(#{config.root}/app/services/locomotive)

      Locomotive::PartialsCell.add_template(:custom_fields_form, "searchable")
      Locomotive::PartialsCell.add_template(:page_form, "searchable")
    end

    initializer "locomotive.search.assets.precompile", group: :all do |app|
      app.config.assets.precompile += ['locomotive/search_bar.css', 'locomotive/search_bar.js']
    end

  end
end