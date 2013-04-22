require 'spec_helper'

describe "Algolia" do
  before do
    setup_search
    require "activesearch/algolia"
    config = YAML.load_file(Rails.root.join('config', 'backends.yml'))
    require "activesearch/algolia/client"
    ActiveSearch::Algolia::Client.configure(config["algolia"]["api_key"], config["algolia"]["app_id"], "locomotivecms")
    ActiveSearch::Algolia::Client.new.delete_index
    Locomotive.config.search_engine = "algolia"
  end
  
  it_behaves_like "a search backend"
end