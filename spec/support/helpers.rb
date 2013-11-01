module SpecHelpers
  def setup_search
    @site = create('test site')
    @ctype = build(:content_type, site: @site, name: "Examples")
    @ctype.entries_custom_fields.build(label: "Name", type: "string", searchable: true)
    @ctype.save!
    @stuff_field = @ctype.entries_custom_fields.build(label: "Stuff", type: "text", searchable: false)
    @stuff_field.save!
    @ctype.entries.create!(name: "Findable entry", stuff: "Some stuff")
    @ctype.entries.create!(name: "Hidden", stuff: "Not findable")
    create(:sub_page, site: @site, title: "Please search for this findable page", slug: "findable", raw_template: "This is what you were looking for")
    create(:sub_page, site: @site, title: "search", slug: "search", raw_template: <<-EOT
      * Search results:
      <ul>
        {% for result in site.search %}
          <li>{{ result }}</li>
          {% if result.content_type_slug == 'examples' %}
            <li><a href="/examples/{{result._slug}}">{{ result.name }}</a></li>
          {% else %}
            <li><a href="/{{result.slug}}">{{ result.title }}</a></li>
          {% endif %}
        {% endfor %}
      </ul>
    EOT
    )

    @index = @site.pages.where(slug: "index").first
    @index.raw_template = %|
       <form action="/{{ locale }}/search" method="GET">
         <label for="search">Search</label>
         <input type="text" name="search" id="search">
         <input type="submit" value="Search">
       </form>|
    @index.save!
    another_site = create('another site')
    create(:page, site: another_site, title: "This should never show up in the search, even if it would be findable", slug: "rickroll", raw_template: "Rickroll")
    ctype = build(:content_type, site: another_site, name: "Examples")
    ctype.entries_custom_fields.build(label: "Name", type: "string", searchable: true)
    ctype.save!
    ctype.entries.create!(name: "NOT Findable entry", stuff: "Some stuff")
  end
end

RSpec.configure { |c| c.include SpecHelpers }