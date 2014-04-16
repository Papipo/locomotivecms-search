module SpecHelpers

  def setup_search_engine
    case SEARCH_ENGINE.to_sym
    when :mongoid
      ActiveSearch::Mongoid::Index.create_indexes
    when :algolia
      config = YAML.load_file(Rails.root.join('config', 'backends.yml'))
      require "activesearch/algolia/client"
      ActiveSearch::Algolia::Client.configure(config["algolia"]["api_key"], config["algolia"]["app_id"], "locomotivecms-search_dev")
      ActiveSearch::Algolia::Client.new.delete_index
    end
  end

  def setup_search
    @site = create('test site')

    authors = build(:content_type, site: @site, name: "Authors")
    authors.entries_custom_fields.build(label: "Fullname", type: "string", searchable: true)
    authors.save!

    examples = build(:content_type, site: @site, name: "Examples")
    examples.entries_custom_fields.build(label: "Name", type: "string", searchable: true)
    examples.entries_custom_fields.build(label: 'Author', type: 'belongs_to', class_name: authors.entries_class_name, searchable: true)
    examples.entries_custom_fields.build(label: "Stuff", type: "text", searchable: false)
    examples.save!

    @ctype = examples

    authors.entries_custom_fields.build(label: "Examples", type: "has_many", class_name: examples.entries_class_name, inverse_of: 'author', searchable: true)
    authors.save!

    author = authors.entries.create!(fullname: 'John Doe')
    examples.entries.create!(name: "Findable entry", stuff: "Some stuff", author: author)
    examples.entries.create!(name: "Hidden", stuff: "Not findable")
    create(:sub_page, site: @site, title: "Please search for this findable page", slug: "findable", raw_template: "This is what you were looking for", searchable: true)
    create(:sub_page, site: @site, title: "Unpublished findable", slug: "unpublished-findable", raw_template: "Not published, so can't be found", searchable: true, published: false)
    create(:sub_page, site: @site, title: "Seems findable", slug: "seems-findable", raw_template: "Even if it seems findable, it sound't be found because of the searchable flag", searchable: false)
    create(:sub_page, site: @site, title: "search", slug: "search", raw_template: <<-EOT
      <html>
      <body>
      {% search_for params.search, page: params.page, per_page: 2 %}
      * Total entries: {{ search.total_entries }}
      * Search results:
      <ul>
        {% for result in search.results %}
          {% if result.content_type_slug == 'examples' %}
            <li><a href="/examples/{{result._slug}}">{{ result.name }}</a></li>
          {% else %}
            <li><a href="/{{result.fullpath}}">{{ result.title }}</a></li>
          {% endif %}
        {% endfor %}
      </ul>
      {% endsearch_for %}
      </body>
      </html>
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

  def fill_typeahead(field, value, suggestion)
    # make sure the search bar is present
    page.evaluate_script(%Q{ $('#{field}').size() }).should == 1

    # open the search bar and look for a string
    page.execute_script %Q{ $('#{field} .twitter-typeahead').click() }
    page.execute_script %Q{ $('#{field} input[name=keywords]').typeahead('val', "#{value}").focus().keydown() }
    page.execute_script %Q{ $('#{field} input[name=keywords]').typeahead('val', "#{value} ").focus().keydown() }
    # FIXME: bad stuff
    sleep SEARCH_ENGINE.to_sym == :algolia ? 1.5 : 0.5

    # DEBUG
    # Capybara::Screenshot.screenshot_and_open_image

    page.evaluate_script(%Q{ $('.tt-suggestion:contains("#{suggestion}")').size() }).should >= 1
  end
end

RSpec.configure { |c| c.include SpecHelpers }