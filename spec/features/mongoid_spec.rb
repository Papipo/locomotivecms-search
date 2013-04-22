require 'spec_helper'

describe "Mongoid" do
  before do
    setup_search
    require "activesearch/mongoid"
    Locomotive.config.search_engine = "mongoid"
  end
  
  it_behaves_like "a search backend"
end