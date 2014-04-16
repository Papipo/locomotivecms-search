shared_examples "a search backend" do
  it "that works" do
    visit 'http://test.example.com'
    fill_in "Search", with: "findable"
    click_on "Search"
    page.should have_content "Please search for this findable page"
    page.should have_content "Findable entry"
    page.should_not have_content "Unpublished findable"
    page.should_not have_content "Seems findable"
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

  it "that is able to index modified content types" do
    @ctype.entries_custom_fields.last.searchable = true
    @ctype.save
    visit 'http://test.example.com'
    fill_in "Search", with: "stuff"
    click_on "Search"
    page.should_not have_content "Findable entry"
    Locomotive::Search::ContentTypeReindexer.new.perform(@ctype.id)
    visit 'http://test.example.com'
    fill_in "Search", with: "stuff"
    click_on "Search"
    page.should have_content "Total entries: 1"
    page.should have_content "Findable entry"
  end
end

shared_examples "search from the back-office" do

  it "displays the autocomplete search bar", js: true do
    visit 'http://test.example.com:7171/locomotive'

    fill_in "Email", with: "admin@locomotiveapp.org"
    fill_in "Password", with: "easyone"
    click_button "Log in"

    click_link 'Contents'
    fill_typeahead '#search-bar', 'findable', 'Please search for this findable page'
  end

end