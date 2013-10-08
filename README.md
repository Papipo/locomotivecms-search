# LocomotiveCMS search

## Setup

Open your _Gemfile_ and add locomotive-cms search to it:

    gem 'locomotivecms-search', require: 'locomotive/search/mongoid'

Check out the Activesearch gem to know which backends are available and how to configure them.

Run `bundle install`

## Adding the search results page

Create a new page that will display your search results. Its code might be something like this:

    {% for result in site.search %}
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

## Note for mongoid 2.x users

If you are using the mongoid engine and still on 2.x, you must use locomotivecms-search version ~> 0.0.5

This project rocks and uses MIT-LICENSE.