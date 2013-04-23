SEARCH_ENGINE = 'algolia'
require 'spec_helper'

describe "Algolia" do
  before do
    config = YAML.load_file(Rails.root.join('config', 'backends.yml'))
    require "activesearch/algolia/client"
    ActiveSearch::Algolia::Client.configure(config["algolia"]["api_key"], config["algolia"]["app_id"], "locomotivecms")
    ActiveSearch::Algolia::Client.new.delete_index
    setup_search
  end
  
  it_behaves_like "a search backend"
end