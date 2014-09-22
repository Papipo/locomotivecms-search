# LocomotiveCMS search [WAGON]

## Setup

Open your _Gemfile_ and add wagon search to it:

    gem 'locomotivecms-search-wagon'

Run `bundle install`

## Adding the search results page

    {% search_for params.query, per_page: 10, page: params.page %}

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

This project rocks and uses MIT-LICENSE.