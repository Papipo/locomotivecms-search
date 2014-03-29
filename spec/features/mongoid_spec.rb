SEARCH_ENGINE = 'mongoid'
require 'spec_helper'

describe "Mongoid" do
  before do
    setup_search_engine
    setup_search
  end

  it_behaves_like "a search backend"

  include_examples "search from the back-office"
end