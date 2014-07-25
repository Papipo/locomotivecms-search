# LocomotiveCMS search

## Setup

Open your _Gemfile_ and add locomotive-cms search to it:

    gem 'locomotivecms-search', require: 'locomotive/search/mongoid'

Check out the Activesearch gem to know which backends are available and how to configure them.

Run `bundle install`

## Adding the search results page

[New way]

    {% search_for params.search, per_page: 10, page: params.page %}

    <p>{{ search.total_entries }} elements found.</p>

    <ul>
    {% for result in search.results %}
      <li><a href="/{{result.slug}}">{{ result.title }}</a></li>
    {% endfor %}
    </ul>

    {% if search.total_pages > params.page %}
      <p>
        <a href="?page={{ params.page | plus: 1 }}&query={{ params.query }}">Next page</a>
      </p>
    {% endif %}

    {% endsearch_for %}

[Old way]

Create a new page that will display your search results. Its code might be something like this:

    {% for result in site.search.results%}
      <li><a href="/{{result.slug}}">{{ result.title }}</a></li>
    {% endfor %}

As you can see, when a search string is passed in the URL, you can fetch the results by using `site.search`.
Choose a good __slug__, like "search".

## Adding the search form

Anywhere on your site you can add a simple form to fire a search. This could be done on the homepage, on a page you are inheriting from, on even on a snippet.
Just add this code:

    <form action="/{{ locale }}/search" method="GET">
      <label for="search">Search</label>
      <input type="text" name="search" id="search">
      <input type="submit" value="Search">
    </form>

The important part is the action parameter, since __it must point to the slug of your search results page__.
Also, the name of the search input must be "search".

## Search from the back-office

From the 0.3.0 version, this gem includes a search bar for your LocomotiveCMS back-office. This search bar uses the [typeahead](http://twitter.github.io/typeahead.js/) javascript plugin.

The only requirement is to have the **LocomotiveCMS 2.5.x** version installed.

In your **LocomotiveCMS main application** (the one embedding LocomotiveCMS), you need to add 2 files (or edit them if they already exist).

In the *app/views/locomotive/shared/_main_app_head.html.haml* file, add these 2 lines:

    = javascript_include_tag  'locomotive/search_bar'
    = stylesheet_link_tag     'locomotive/search_bar'

In the *app/views/locomotive/shared/_main_app_header.html.haml* file, add this line:

      = render 'locomotive/shared/search_bar'


## Note for mongoid 2.x users

If you are using the mongoid engine and still on 2.x, you must use locomotivecms-search version ~> 0.0.5

This project rocks and uses MIT-LICENSE.
