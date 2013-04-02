require 'spec_helper'

feature "Search" do
  before do
    @site = create('test site')
    @ctype = build(:content_type, site: @site, name: "Examples")
    @ctype.entries_custom_fields.create!(label: "Name", type: "string", searchable: true)
    @ctype.entries_custom_fields.create!(label: "Stuff", type: "text", searchable: false)
    @ctype.entries.create!(name: "Findable entry", stuff: "Some stuff")
    @ctype.entries.create!(name: "Hidden", stuff: "Not findable")
    create(:sub_page, site: @site, title: "Please search for this findable page", slug: "findable", raw_template: "This is what you were looking for")
    create(:sub_page, site: @site, title: "search", slug: "search", raw_template: <<-EOT)
       <ul>
       {% for result in site.search %}
         {% if result.content_type_slug == 'examples' %}
           <li><a href="/examples/{{result._slug}}">{{ result.name }}</a></li>
         {% else %}
           <li><a href="/{{result.slug}}">{{ result.title }}</a></li>
         {% endif %}
       {% endfor %}
       </ul>
    EOT
    
    @index = @site.pages.where(slug: "index").first
    @index.raw_template = %|
       <form action="/{{ locale }}/search" method="GET">
         <label for="search">Search</label>
         <input type="text" name="search" id="search">
         <input type="submit" value="Search">
       </form>|
    @index.save!
    @another_site = create('another site')
    create(:page, site: @another_site, title: "This should never show up in the search, even if it would be findable", slug: "rickroll", raw_template: "Rickroll")
  end
  
  scenario "on a single site" do
    visit 'http://test.example.com'
    fill_in "Search", with: "findable"
    click_on "Search"
    page.should have_content "Please search for this"
    page.should have_content "Findable entry"
    page.should_not have_content "Hidden"
    page.should_not have_content "This should never show up"
    click_on "Please search for this"
    page.should have_content "This is what you were looking for"
    
    visit 'http://test.example.com'
    fill_in "Search", with: "not found"
    click_on "Search"
    page.should_not have_content "Page not found"
  end
end