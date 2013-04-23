# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.dirname(__FILE__) + '/dummy/config/environment'
require 'rspec/rails'
require 'rspec/autorun'
require 'factory_girl'
require 'database_cleaner'
require 'activesearch'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
require Locomotive::Engine.root.join('spec', 'support', 'factories')
Dir[Locomotive::Search::Engine.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
  
  config.include FactoryGirl::Syntax::Methods
  
  config.before(:each) do
    Mongoid.master.collections.select { |c| c.name != 'system.indexes' }.each(&:drop)
  end
  
  config.after(:each) do
    Mongoid.master.collections.select { |c| c.name != 'system.indexes' }.each(&:drop)
  end
end

shared_examples "a search backend" do
  it "that works" do
    visit 'http://test.example.com'
    fill_in "Search", with: "findable"
    click_on "Search"
    page.should have_content "Please search for this"
    page.should have_content "Findable entry"
    page.should_not have_content "Hidden"
    page.should_not have_content "This should never show up"
    page.should_not have_content "NOT Findable entry"
    click_on "Please search for this"
    page.should have_content "This is what you were looking for"

    visit 'http://test.example.com'
    fill_in "Search", with: "not found"
    click_on "Search"
    page.should_not have_content "Page not found"
  end
end