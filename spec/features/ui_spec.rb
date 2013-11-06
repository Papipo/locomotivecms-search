SEARCH_ENGINE = 'mongoid'
require 'spec_helper'

feature "User interface" do
  background do
    setup_search
  end
  
  scenario "Searchable flag in content type form", js: true do
    visit 'http://test.example.com:7171/locomotive'
    
    fill_in "Email", with: "admin@locomotiveapp.org"
    fill_in "Password", with: "easyone"
    click_button "Log in"
    
    click_link "new model"
    fill_in "Name", with: "Posts"
    fill_in "Field name", with: "Title"
    click_link "add"
    find('.actions .toggle').click
    page.should have_content "Searchable"
  end
  
  scenario "Searchable flag in page form", js: true do
    visit 'http://test.example.com:7171/locomotive'
    
    fill_in "Email", with: "admin@locomotiveapp.org"
    fill_in "Password", with: "easyone"
    click_button "Log in"
    
    click_link "new page"
    page.should have_content "Searchable"
  end
end