SEARCH_ENGINE = 'algolia'
require 'spec_helper'

describe "Algolia" do
  before do
    setup_search_engine
    setup_search
  end

  it_behaves_like "a search backend"

  include_examples "search from the back-office"
end